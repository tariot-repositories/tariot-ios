//
//  DeliveryOrderRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Foundation

final class DeliveryOrderRepository {
    private let baseURL = URL(string: "http://127.0.0.1:8000")!
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func fetchActiveOrder() async throws -> DeliveryOrder? {
        let url = baseURL.appendingPathComponent("tasks/get-delivery-task")
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        switch http.statusCode {
        case 204:
            return nil
        case 200..<300:
            return try decoder.decode(DeliveryOrder.self, from: data)
        default:
            throw APIError.badResponse
        }
    }
    
    func acceptActiveOrder(order: DeliveryOrder) async throws -> Bool {
        
        return true
    }
}

enum APIError: Error { case badResponse }
