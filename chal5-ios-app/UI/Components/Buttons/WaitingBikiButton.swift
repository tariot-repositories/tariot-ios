//
//  WaitingBikiButton.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

import SwiftUI

struct WaitingBikiButton: View {
    let title: String = "Menunggu konfirmasi BIKI..."
    let action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.custom("Inter-Regular_Bold", size: 14))
                    .foregroundStyle(.greyButtonText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.waitingBikiButton)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }.disabled(true)
    }
}
