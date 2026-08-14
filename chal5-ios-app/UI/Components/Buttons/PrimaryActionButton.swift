//
//  PrimaryButton.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

import SwiftUI

struct PrimaryActionButton: View {
    let title: String = "Halo"
    var isLoading: Bool = true
    let action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.darkGreen)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isLoading)
    }
}
