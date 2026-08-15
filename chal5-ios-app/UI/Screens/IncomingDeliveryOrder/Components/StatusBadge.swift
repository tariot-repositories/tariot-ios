//
//  StatusBadge.swift
//  chal5-ios-app
//
//  Created by Danniel on 15/08/26.
//
import SwiftUI

struct StatusBadge: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text)
                .font(
                    .custom("Inter-Regular_Bold", size: 10)
                )
                .tracking(
                    0.3
                )
                .foregroundStyle(color)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
    }
}

