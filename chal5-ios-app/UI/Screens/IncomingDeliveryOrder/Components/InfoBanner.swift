//
//  InfoBanner.swift
//  chal5-ios-app
//
//  Created by Danniel on 15/08/26.
//

import SwiftUI

struct InfoBanner: View {
    let title: String
    let message: String
    let titleColor: Color
    let backgroundColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("Inter-Regular_Bold", size: 12))
                .tracking(0.96)
                .foregroundStyle(titleColor)
            Text(message)
                .font(.caption)
                .tracking(0.12)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
