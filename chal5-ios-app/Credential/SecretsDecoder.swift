//
//  Secret.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

import Foundation

enum Secrets {
    static var myTruckId: UUID = UUID(uuidString: "cef46e10-2ca0-4743-bce5-2ce9bf36aa36")!
    static var slaveCount: Int = 2
    static var masterCode: String = "m1"

    static var mqttHost: String {
        guard let key = Bundle.main.infoDictionary?["MQTT_HOST"] as? String else {
            fatalError("Missing MQTT HOST")
        }
        
        return key
    }
    
    static var mqttUsername: String {
        guard let key = Bundle.main.infoDictionary?["MQTT_USERNAME"] as? String else {
            fatalError("Missing MQTT Username")
        }

        return key
    }
    
    static var mqttPassword: String {
        guard let key = Bundle.main.infoDictionary?["MQTT_PASSWORD"] as? String else {
            fatalError("Missing MQTT password")
        }

        return key
    }
    
    static var mqttPort: UInt16 {
        guard let raw = Bundle.main.infoDictionary?["MQTT_PORT"] as? String,
              let port = UInt16(raw) else {
            fatalError("Missing or invalid MQTT Port")
        }
        return port
    }
}
