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

struct Alert: Decodable, Identifiable {
    let id: UUID
    let slaveCode: String
    let truckUUID: UUID
    let readingID: UUID
    let parameter: AlertParameter
    let severity: AlertSeverity
    let valueAtTrigger: Double
    let message: String
    let createdAt: String
}
