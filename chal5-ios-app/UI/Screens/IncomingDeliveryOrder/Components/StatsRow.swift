//
//  Stats.swift
//  chal5-ios-app
//
//  Created by Danniel on 15/08/26.
//

import SwiftUI

struct StatItem {
    let label: String
    let value: String
}

struct StatsRow: View {
    let stats: [StatItem]

    var body: some View {
        HStack {
            ForEach(stats.indices, id: \.self) { i in
                VStack(alignment: .leading, spacing: 4) {
                    Text(stats[i].label)
                        .font(
                            .custom("Inter-Regular_Bold", size: 9)
                        )
                        .tracking(0.06 * 9)
                        .foregroundStyle(.greyText)
                    Text(stats[i].value)
                        .font(
                            .custom("Inter-Regular_Bold", size: 14)
                        )
                        .foregroundStyle(.black)
                }
                if i != stats.count - 1 { Spacer() }
            }
        }
        .padding(16)
        .background(Color.statsRow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
