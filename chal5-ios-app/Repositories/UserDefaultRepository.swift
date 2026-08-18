//
//  UserDefaultRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 18/08/26.
//

import Foundation

final class UserDefaultRepository {
    static let shared = UserDefaultRepository()
    
    func setOnDeliveryDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "onDeliveryDate")
    }
    
    func setNilOnDeliveryDate() {
        UserDefaults.standard.set(nil, forKey: "onDeliveryDate")
    }
    
    func getOnDeliveryDate() -> Date {
        if UserDefaults.standard.object(forKey: "onDeliveryDate") == nil {
            UserDefaults.standard.set(Date.now, forKey: "onDeliveryDate")
        }
        
        return UserDefaults.standard.object(forKey: "onDeliveryDate") as? Date ?? Date.now
    }
}
