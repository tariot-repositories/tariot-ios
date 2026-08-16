//
//  CrateRow.swift
//  chal5-ios-app
//
//  Created by Danniel on 16/08/26.
//

import SwiftUI

struct CrateRow: View {
    var isDetected: Bool
    var code: String
    
    init (isDetected: Bool, code: String) {
        self.isDetected = isDetected
        self.code = code.uppercased()
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(isDetected ? Color.green : Color.red)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(code)
                    .font(
                        .custom("Inter-Regular_Bold", size: 13.5)
                    )
                    .foregroundColor(.black)

                Text(isDetected ? "terdeteksi" : "gagal terdeteksi")
                    .font(
                        .custom("Inter-Regular_Medium", size: 11)
                    )
                    .foregroundColor(isDetected ? .ligthGreen : .danger)
            }

            Spacer()

            if isDetected {
                Image(systemName: "checkmark")
                    .font(
                        .custom("Inter-Regular_Bold", size: 14)
                    )
                    .foregroundColor(.ligthGreen)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
    }
}
