//
//  Mock.swift
//  chal5-ios-app
//
//  Created by Danniel on 18/08/26.
//

import Foundation

enum Mock {
    static let deliveryOrder = DeliveryOrder(
        id: 1042,
        truckID: UUID(),
        originLocation: "Jakarta Warehouse A",
        destinationLocation: "Bandung Distribution Hub B",
        departureScheduledAt: Date().description,
        status: .menungguDeteksiNode,
        createdBy: 1,
        createdAt: Date.now.description,
        completedAt: nil,
        startedAt: nil
    )

}
