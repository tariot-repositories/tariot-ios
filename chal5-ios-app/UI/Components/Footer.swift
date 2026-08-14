//
//  Footer.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

import SwiftUI

extension View {
    func actionFooter<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        self.safeAreaInset(edge: .bottom, spacing: 0) {
            content()
                .padding(.top, 24)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(
                    Color.footerBackground
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -4)
                        .ignoresSafeArea(edges: .bottom)
                )
                .compositingGroup()
        }
    }
}
