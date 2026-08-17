//
//  OnDeliveryView.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import SwiftUI

struct OnDeliveryView: View {
    var body: some View {
        VStack {
            Header()
            OnGoingStatusBar(originLocation: "Kebun Mitra Sleman", destinationLocation: "Lotte Mart Semarang", dateStart: Date.now)
            Spacer()
        }
        .actionFooter {
            PrimaryActionButton(
                title: "Selesaikan perjalanan", isLoading: false
            ) {
                
            }
        }
    }
}

#Preview {
    OnDeliveryView()
}
