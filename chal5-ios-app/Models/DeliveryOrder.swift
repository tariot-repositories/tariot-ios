//
//  E.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Foundation

struct DeliveryOrder: Codable, Hashable {
    let id: Int
    let truckID: UUID
    let originLocation: String
    let destinationLocation: String
    let departureScheduledAt: String
    var status: DeliveryStatus
    let createdBy: Int
    let createdAt: String
    let completedAt: String?
}

struct DriverDeliveryDTO: Codable, Hashable {
    let id: Int
    let truckID: UUID
    let originLocation: String
    let destinationLocation: String
    let departureScheduledAt: Int64
    let status: DeliveryStatus
    let createdAt: Int
    let completedAt: Int?
    let createdBy: Int
}

enum DeliveryStatus: String, Codable {
    case dibuat
    case menungguKonfirmasiSupir  = "menunggu_konfirmasi_supir"
    case menungguDeteksiNode      = "menunggu_deteksi_node"
    case dalamPerjalanan          = "dalam_perjalanan"
    case selesai
}

extension DeliveryOrder {
    init(from dto: DriverDeliveryDTO) {
        self.id = dto.id
        self.truckID = dto.truckID
        self.originLocation = dto.originLocation
        self.destinationLocation = dto.destinationLocation
        self.departureScheduledAt = Date(timeIntervalSince1970: TimeInterval(dto.departureScheduledAt)).description
        self.status = dto.status
        self.createdBy = dto.createdBy
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(dto.createdAt)).description
        self.completedAt = dto.completedAt.map { Date(timeIntervalSince1970: TimeInterval($0)).description }
    }
}

