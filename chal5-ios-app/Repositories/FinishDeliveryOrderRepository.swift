//
//  FinishDeliveryOrderRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 18/08/26.
//

import Foundation

final class FinishDeliveryOrderRepository {
    static let shared = FinishDeliveryOrderRepository()
    
    private let baseURL = URL(string: Secrets.hostUrl)!
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
    }
    
    func finishDeliveryOrder(order: DeliveryOrder) async throws -> DeliveryOrder {
        let url = baseURL.appendingPathComponent("deliveries/\(order.id)/status")
        var request = URLRequest(url: url)
        
        var copy: DeliveryOrder = order
        copy.status = .selesai
        
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONEncoder().encode(copy)
        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }
        
        switch http.statusCode {
        case 200..<300:
            return try decoder.decode(DeliveryOrder.self, from: data)
            
        default:
            throw APIError.badResponse
        }
    }
}
