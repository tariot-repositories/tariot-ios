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

extension Date {
    /// Parses a string produced by `Date.description` / `NSDate.description`,
    /// e.g. "2026-08-18 01:23:45 +0000", back into a `Date`.
    ///
    /// `Date.description` is always rendered in UTC using the fixed format
    /// "yyyy-MM-dd HH:mm:ss Z" — it does not depend on the device's locale or
    /// timezone, so the formatter below is pinned to `en_US_POSIX` + UTC to
    /// match that exactly, not whatever the user's device happens to be set to.
    static func from(descriptionString: String) -> Date {
        descriptionFormatter.date(from: descriptionString) ?? Date.now
    }
 
    private static let descriptionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
}
