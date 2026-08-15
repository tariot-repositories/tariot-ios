//
//  TaskCard.swift
//  chal5-ios-app
//
//  Created by Danniel on 15/08/26.
//

import SwiftUI

struct TaskCard: View {
    let code: String
    let badgeText: String
    let badgeColor: Color
    let originTitle: String
    let destinationTitle: String
    let stats: [StatItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(code).font(
                    .custom("Inter-Regular_Bold", size: 24)
                )
                .tracking(24 * 0.01)
                .foregroundStyle(Color.black)
                Spacer()
                StatusBadge(text: badgeText, color: badgeColor)
            }

            RouteTimelineView(
                originTitle: originTitle,
                destinationTitle: destinationTitle,
            )

            StatsRow(stats: stats)
        }
        .padding(22)
        .background(
            Color.white
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.shadow, radius: 24, x: 0, y: 8)
    }
}
