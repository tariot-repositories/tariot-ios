//
//  Header.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//
import SwiftUI

struct Header : View {
    var body: some View {
        HStack(spacing: 0) {
            VStack (alignment: .leading, spacing: 4) {
                Text("MONITORING · BIKI 4")
                    .font(.custom("Inter-Regular_ExtraBold", size: 12))
                    .tracking(12 * 0.12)
                    .foregroundStyle(.ligthGreen)
                Text("BIKI ALERT")
                    .font(.custom("BricolageGrotesque-96ptExtraBold_Bold", size: 27))
                    .tracking(0.05)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}
