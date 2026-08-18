//
//  AlertStatus.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import SwiftUI

enum AlertStatus {
    case safe
    case needsAction

    var title: String {
        switch self {
        case .safe: return "Aman"
        case .needsAction: return "Perlu Tindakan"
        }
    }

    var iconName: String {
        switch self {
        case .safe: return "checkmark"
        case .needsAction: return "exclamationmark.triangle.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .safe: return Color.alertBannerSafe
        case .needsAction: return Color.infoBannerBackground
        }
    }
}

// MARK: - Status Banner Component

struct StatusBanner: View {
    let status: AlertStatus
    let updatedAt: Date

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            iconView
                .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 0) {
                Text(status.title)
                    .font(
                        .custom("Inter-Regular_Bold", size: 14)
                    )
                    .foregroundColor(.black)
                    .tracking(0.03 * 14)
                    .padding(.bottom, 10)

                Text(status == .safe ? "Kondisi keranjang buah berada dalam rentang batas normal." : "Terdeteksi kondisi keranjang berada di luar rentang batas normal.")
                    .font(.custom("Inter-Regular_Medium", size: 12))
                    .foregroundColor(.black)
                    .tracking(0.03 * 12)
                    .padding(.bottom, 10)

                HStack {
                    Spacer()
                    Text("Terakhir diperbarui \(formatTime(from: updatedAt))")
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(status.backgroundColor)
        )
    }

    @ViewBuilder
    private var iconView: some View {
        switch status {
        case .safe:
            Image(systemName: "checkmark.circle")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.checkmarkIcon)
        case .needsAction:
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.infoBannerTitle)
        }
    }
}

// MARK: - Preview

struct StatusBannerPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            StatusBanner(
                status: .safe,
                updatedAt: Date.now
            )

            StatusBanner(
                status: .needsAction,
                updatedAt: Date.now
            )
        }
        .padding(20)
    }
}

#Preview {
    StatusBannerPreview()
}
