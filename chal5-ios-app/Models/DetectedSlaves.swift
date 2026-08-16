//
//  DetectedSlaves.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

struct DetectedSlaves: Codable {
    let deliveryId: Int
    let masterCode: String
    let truckId: Int
    let detectedSlaves: [SlaveData]
    let createdBy: Int
    
    enum CodingKeys: String, CodingKey {
        case deliveryId = "delivery_id"
        case masterCode = "master_code"
        case truckId = "truck_id"
        case detectedSlaves = "detected_slaves"
        case createdBy = "created_by"
    }
}
