//
//  RootView.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = RootViewModel()
    @StateObject var router: Router = .shared
    
    var body: some View {
        NavigationStack (path: $router.path) {
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
            .navigationDestination (for: Route.self) {
                route in RouteDestinationView(route: route)
            }
        }
    }
}

#Preview ("Root View") {
    RootView()
}
