//
//  DetectedSlaves.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

struct DetectedSlaves: Codable {
    let deliveryId: Int
    let masterCode: String
    let detectedSlaves: [SlaveData]
    
    enum CodingKeys: String, CodingKey {
        case deliveryId = "delivery_id"
        case masterCode = "master_code"
        case detectedSlaves = "slave_detected"
    }
}
