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

enum DeliveryStatus: String, Codable {
    case dibuat
    case menungguKonfirmasiSupir  = "menunggu_konfirmasi_supir"
    case menungguDeteksiNode      = "menunggu_deteksi_node"
    case dalamPerjalanan          = "dalam_perjalanan"
    case selesai
}
