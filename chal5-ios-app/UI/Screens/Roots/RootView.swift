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
        switch viewModel.state {
        case .idle:
            LoadingView()
                .task {
                    await viewModel.loadActiveOrder()
                }
        case .loading:
            LoadingView()
        case .deliveryNotAccepted(let order):
            DeliveryOrderView(viewModel: DeliveryOrderViewModel(state: DeliveryOrderViewModel.State.loaded(order)))
        case .nodeDetectionState:
            EmptyView()
        case .failed(let message):
            ErrorView(message: message, retryAction: {
                Task {
                    await viewModel.loadActiveOrder()
                }
            })
        default:
            EmptyView()
        }
    }
}

#Preview ("Root View") {
    RootView()
}
