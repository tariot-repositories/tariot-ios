//
//  E.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Foundation

struct DeliveryOrder: Codable, Identifiable, Hashable {
    let id: Int
    let truckId: Int
    let originLocation: String
    let destinationLocation: String
    let departureScheduledAt: Date
    let estimatedArrivalAt: Date
    let status: String
    let createdAt: Date
    let completedAt: Date?
    let createdBy: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case truckId = "truck_id"
        case originLocation = "origin_location"
        case destinationLocation = "destination_location"
        case departureScheduledAt = "departure_scheduled_at"
        case estimatedArrivalAt = "estimated_arrival_at"
        case status = "status"
        case createdAt = "created_at"
        case completedAt = "completed_at"
        case createdBy = "created_by"
    }
}
