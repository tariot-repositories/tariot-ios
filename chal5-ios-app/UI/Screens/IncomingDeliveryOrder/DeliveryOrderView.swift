//
//  IncomingTaskList.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import SwiftUI
import Combine

struct DeliveryOrderView: View {
    @ObservedObject var viewModel: DeliveryOrderViewModel
    @StateObject var router: Router = Router()
    
    init(viewModel: DeliveryOrderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .task {
                await viewModel.loadActiveOrder()
            }
    }
    
    @ViewBuilder var content: some View {
        NavigationStack (path: $router.path) {
            Group {
                switch viewModel.state {
                case .idle:
                    Color.clear
                case .loading:
                    LoadingView()
                case .loaded(let deliveryOrder):
                    loadedView(deliveryOrder)
                case .failed(let message):
                    ErrorView(message: message, retryAction: retry)
                }
            }.navigationDestination (for: Route.self) {
                route in RouteDestinationView(route: route)
            }
        }
    }
}

// MARK: Loaded View

private extension DeliveryOrderView {
    func loadedView(_ order: DeliveryOrder?) -> some View {
        Group {
            if let order {
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    Text("Order #\(order.id)")
                        .font(.headline)
                    Text("\(order.originLocation) → \(order.destinationLocation)")
                    Text("Status: \(order.status)")
                    
                    Spacer()
                    
                    retryButton()
                    Button("Terima Pesanan BIKI") {
                        Task {
                            await viewModel.acceptActiveOrder(order: order)
                        }
                    }.disabled(viewModel.acceptingDeliveryState == DeliveryOrderViewModel.AcceptingDeliverState.acceptingDeliverOrder)
                    Spacer()
                }
                .padding()
                .onChange(of: viewModel.acceptingDeliveryState) { _, newState in
                    if newState == .detectionNodePhase {
                        router.push(.nodeDetection(order))
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("No active delivery order")
                        .foregroundStyle(.secondary)
                    retryButton()
                }
            }
        }
    }
}

// MARK: Util
private extension DeliveryOrderView {
    func retryButton() -> some View {
        Button("Retry") {
            retry()
        }
    }
    
    func retry() {
        Task { await viewModel.loadActiveOrder() }
    }
}

#Preview ("Delivery Order View"){
    DeliveryOrderView(viewModel: DeliveryOrderViewModel(state: DeliveryOrderViewModel.State.idle))
}
