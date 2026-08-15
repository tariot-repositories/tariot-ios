//
//  Error.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    init (message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }
    
    var body: some View {
        ZStack {
            Color.veryLigthGreen.ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
                Text("Something went wrong:\n\(message)")
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    retryAction()
                }
            }
        }
    }
}
