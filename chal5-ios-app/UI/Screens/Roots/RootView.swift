//
//  RootView.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = RootViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                VStack (spacing: 0) {
                    Header()
                    Spacer()
                    LoadingView()
                    Spacer()
                }
                .background(
                    Color.veryLigthGreen
                )
            case .noDelivery:
                DeliveryOrderView(viewModel: DeliveryOrderViewModel(deliveryOrder: viewModel.deliveryOrder))
            case .deliveryNotAccepted:
                DeliveryOrderView(viewModel: DeliveryOrderViewModel(deliveryOrder: viewModel.deliveryOrder))
            case .nodeDetectionState:
                NodeSlaveDetection(
                    viewModel: NodeSlaveDetectionViewModel(order: viewModel.deliveryOrder!)
                )
            default:
                EmptyView()
            }
        }
        .task {
            await viewModel.refreshUntilGetActiveOrder()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview ("Root View") {
    RootView()
}
