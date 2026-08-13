//
//  RootView.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = RootViewModel()
    @StateObject var router: Router = Router()
    
    var body: some View {
        NavigationStack (path: $router.path) {
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView()
                case .deliveryNotAccepted(let order):
                    DeliveryOrderView(viewModel: DeliveryOrderViewModel(state: DeliveryOrderViewModel.State.loaded(order)))
                case .nodeDetectionState(let order):
                    NodeSlaveDetection(
                        viewModel: NodeSlaveDetectionViewModel(order: order)
                    )
                    
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
            .task {
                await viewModel.loadActiveOrder()
            }
            .navigationDestination (for: Route.self) {
                route in RouteDestinationView(route: route)
            }
        }
    }
}

#Preview ("Root View") {
    RootView()
}
