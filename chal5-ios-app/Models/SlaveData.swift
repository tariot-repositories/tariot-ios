//
//  SlavePublishData.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

struct SlaveData: Codable {
    let slaveCode: String
    let secondSinceEpoch: Int64
    
    enum CodingKeys: String, CodingKey {
        case slaveCode = "slave_code"
        case secondSinceEpoch = "timestamp"
    }
}
    
