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
    
    init(viewModel: DeliveryOrderViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack (spacing: 0) {
            
            Header()
            
            Spacer()
            
            content
                .task {
                    await viewModel.loadActiveOrder()
                }
            Spacer()
            
        }
        .actionFooter {
            PrimaryActionButton()
        }
        .background(
            Color.veryLigthGreen
        )
    }
    
    @ViewBuilder var content: some View {
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
                        Router.shared.push(.nodeDetection(order))
                    }
                }
            } else {
                VStack(alignment: .center, spacing: 40) {
                    Text("Belum terdapat tugas aktif.")
                        .font(.custom("Inter-Regular_Bold", size: 18))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    Text("Silakan menghubungi Admin Logistik untuk mengonfirmasi pengiriman.")
                        .font(.custom("Inter-Regular_Light", size: 14))
                        .foregroundStyle(Color.greyText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
//                    retryButton()
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
