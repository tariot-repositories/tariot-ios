//
//  IncomingTaskList.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import SwiftUI

struct DeliveryOrderView: View {
    @StateObject var viewModel = DeliveryOrderViewModel()
    
    var body: some View {
        content
            .task {
                await viewModel.loadActiveOrder()
            }
    }
    
    @ViewBuilder var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            loadingView
        case .loaded(let deliveryOrder):
            loadedView(deliveryOrder)
        case .failed(let message):
            failedView(message)
        }
    }
}

// MARK: Load View

private extension DeliveryOrderView {
    var loadingView: some View {
        ProgressView("Loading...")
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
                        // Action Later
                    }
                    
                    Spacer()
                }
                .padding()
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
    
    // MARK: Failed/Error
    
    private extension DeliveryOrderView {
        func failedView(_ message: String) -> some View {
            VStack(spacing: 12) {
                Text("Something went wrong: \(message)")
                Button("Retry") {
                    Task { await viewModel.loadActiveOrder() }
                }
            }
        }
    }
    
    // MARK: Util
    private extension DeliveryOrderView {
        func retryButton() -> some View {
            Button("Retry") {
                Task { await viewModel.loadActiveOrder() }
            }
        }
    }
    
    #Preview {
        DeliveryOrderView()
    }
