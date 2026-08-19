//
//  AlertApiRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import Foundation

final class AlertsAPIRepository {
    static let shared: AlertsAPIRepository = AlertsAPIRepository()
    
    private let baseURL = URL(string: "http://203.175.11.253:8080/api")!
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
    }
    
    func fetchAlerts() async throws -> [Alert] {
        let url = baseURL.appendingPathComponent("alerts/\(Secrets.myTruckId.uuidString.lowercased())")
        let (data, response) = try await session.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }
        
        switch http.statusCode {
        case 200..<300:
            return try decoder.decode([Alert].self, from: data)
        default:
            throw APIError.badResponse
        }
    }
}
