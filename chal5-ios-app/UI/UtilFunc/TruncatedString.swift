//
//  TruncatedString.swift
//  chal5-ios-app
//
//  Created by Danniel on 16/08/26.
//

func trucatedString (originalText: String, limit: Int) -> String {
    if originalText.count > limit {
        return String(originalText.prefix(limit)) + "..."
    }
    return originalText
}
