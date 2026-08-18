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
            
            content
                .task {
                    await viewModel.refreshUntilGetActiveOrder()
                }
            
            Spacer()
        }
        .alert("Error", isPresented: $viewModel.isAcceptingDeliveryError) {
            Button("Oke") {
                viewModel.isAcceptingDeliveryError = false
            }
        } message: {
            if let error = viewModel.acceptingDeliveryError {
                Text("\(error.errorDescription) \(error.recoverySuggestion)")
            } else {
                Text("Terjadi kesalahan!")
            }
        }
        .actionFooter {
            switch viewModel.state {
            case .loadedButEmpty:
                WaitingBikiButton()
            case .loaded:
                PrimaryActionButton(
                    title: "Terima tugas", isLoading: viewModel.isAcceptingDelivery) {
                        Task {
                            await viewModel.acceptActiveOrder()
                        }
                    }
            }
        }
        .background(
            Color.veryLigthGreen
        )
    }
    
    @ViewBuilder var content: some View {
        switch viewModel.state {
        case .loadedButEmpty:
            loadedViewButEmpty
        case .loaded:
            loadedView
        }
    }
    
}

// MARK: Loaded View but Empty
private extension DeliveryOrderView {
    @ViewBuilder var loadedViewButEmpty: some View {
        Spacer()
        
        VStack(spacing: 40) {
            Text("Belum terdapat tugas aktif.")
                .font(.custom("Inter-Regular_Bold", size: 18))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            Text("Silakan menghubungi Admin Logistik untuk mengonfirmasi pengiriman.")
                .font(.custom("Inter-Regular_Light", size: 14))
                .foregroundStyle(Color.greyText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
    


// MARK: Loaded View
private extension DeliveryOrderView {
    @ViewBuilder var loadedView: some View {
        VStack(spacing: 16) {
            TaskCard(
                code: "BIKI-04",
                badgeText: "TUGAS BARU",
                badgeColor: .green,
                originTitle: viewModel.deliveryOrder?.originLocation ?? "Unknown",
                destinationTitle: viewModel.deliveryOrder?.destinationLocation ?? "Unknown",
                stats: [
                    StatItem(label: "BERANGKAT", value: "06:00"),
                    StatItem(label: "ESTIMASI", value: "09:10"),
                    StatItem(label: "NODE", value: Secrets.masterCode.uppercased())
                ]
            )
            
            InfoBanner(
                title: "SEBELUM BERANGKAT",
                message: "Sebelum melakukan keberangkatan, pastikan semua keranjang buah telah masuk ke dalam bak truk dalam posisi menyala.",
                titleColor: Color.infoBannerTitle,
                backgroundColor: Color.infoBannerBackground)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
