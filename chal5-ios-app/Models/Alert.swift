//
//  Alerts.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import Foundation

enum AlertSeverity: String, Decodable {
    case warning
    case critical
}

enum AlertParameter: String, Decodable {
    case temperature
    case humidity
    case ethylene
}

struct Alert: Decodable {
    let id: UUID
    let truckUUID: UUID
    let readingID: UUID
    let readingRecordedAt: Date
    let parameter: AlertParameter
    let severity: AlertSeverity
    let valueAtTrigger: Double
    let message: String
    let createdAt: Date
}
