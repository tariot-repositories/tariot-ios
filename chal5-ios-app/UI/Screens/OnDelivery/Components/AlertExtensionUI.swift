//
//  AlertExtension.swift
//  chal5-ios-app
//
//  Created by Danniel on 18/08/26.
//
import SwiftUI

extension AlertParameter {
    var label: String {
        switch self {
        case .temperature: return "Suhu"
        case .humidity: return "Kelembaban"
        case .ethylene: return "Gas Etilen"
        }
    }

    var unit: String {
        switch self {
        case .temperature: return "°C"
        case .humidity: return "%"
        case .ethylene: return "ppm"
        }
    }

    var tagColor: Color {
        Color(red: 0.98, green: 0.85, blue: 0.83)
    }
}

extension AlertSeverity {
    var dotColor: Color {
        switch self {
        case .critical: return Color.danger
        case .warning: return Color.orangeWarning
        }
    }
    
    var tagBgColor: Color {
        switch self {
        case .critical: return Color.infoBannerBackground
        case .warning: return Color.infoBannerBackground
        }
    }
    
    var tagTextColor: Color {
        switch self {
        case .critical: return Color.redTomato
        case .warning: return Color.redTomato
        }
    }

    var valueColor: Color {
        switch self {
        case .critical: return Color.danger
        case .warning: return Color.orangeWarning
        }
    }
}
