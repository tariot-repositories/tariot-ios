//
//  DateConverter.swift
//  chal5-ios-app
//
//  Created by Danniel on 16/08/26.
//

import Foundation

func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm" 
    return formatter.string(from: date)
}
