//
//  DeliveryOrderRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Foundation

final class DeliveryOrderRepository {
    static let shared = DeliveryOrderRepository()
    
    private let baseURL = URL(string: "http://203.175.11.253:8080/api")!
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
    }

    func fetchActiveOrder() async throws -> DeliveryOrder? {
        let url = baseURL.appendingPathComponent("deliveries")
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }
        
        switch http.statusCode {
        case 204:
            return nil
        case 200..<300:
            let deliveryOrders = try decoder.decode([DeliveryOrder].self, from: data)
            
            let sortedOrders = deliveryOrders
                .map { order in (order, order.departureScheduledAt) }
                .sorted { $0.1 < $1.1 }
                .map { $0.0 }
            
            for order in sortedOrders {
                if order.truckID != Secrets.myTruckId {
                    continue
                }
                
                if order.status != .selesai {
                    return order
//                    return DeliveryOrder(from: order)
                }
            }

            return nil
            
        default:
            throw APIError.badResponse
        }
    }
    
    func acceptActiveOrder(order: DeliveryOrder) async throws -> DeliveryOrder {
        let url = baseURL.appendingPathComponent("deliveries/\(order.id)/status")
        var request = URLRequest(url: url)
        
        var copy: DeliveryOrder = order
        copy.status = .menungguDeteksiNode
        
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
