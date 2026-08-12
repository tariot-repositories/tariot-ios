//
//  APIClient.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Foundation

protocol APIClientProtocol {
    func get<T: Decodable>(_ endpoint: String) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let baseURL = URL(string: "https://api.example.com")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<T: Decodable>(_ endpoint: String) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        let (data, response) = try await session.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw APIError.badResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func post<Body: Encodable, Response: Decodable>(
        _ endpoint: String, body: Body
    ) async throws -> Response {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw APIError.badResponse
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}   

enum APIError: Error { case badResponse }
