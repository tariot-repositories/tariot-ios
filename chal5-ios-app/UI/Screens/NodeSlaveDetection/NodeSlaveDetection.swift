//
//  NodeSlaveDetection.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI

struct NodeSlaveDetection: View {
    @ObservedObject var viewModel: NodeSlaveDetectionViewModel
    @State private var isExpanded: Bool = false
    
    let totalCount: Int
    
    init(viewModel: NodeSlaveDetectionViewModel) {
        self.viewModel = viewModel
        self.totalCount = viewModel.deliveryOrder.slaveCounts
    }
    
    var body: some View {
        Group {
            VStack (spacing: 0) {
                Header()
                
                StatusBar(
                    originLocation: viewModel.deliveryOrder.originLocation,
                    destinationLocation: viewModel.deliveryOrder.destinationLocation,
                    dateStart: viewModel.deliveryOrder.departureScheduledAt
                )
                
                content
                    .padding(.top, 24)
                
                Spacer()
            }
            .task {
                
            }
            .actionFooter {
                PrimaryActionButton(
                    title: "Konfirmasi Berangkat", isLoading: false) {
                        
                    }
            }
            .background(
                Color.veryLigthGreen
            )
        }.navigationBarBackButtonHidden(true)
    }
}

extension NodeSlaveDetection {
    @ViewBuilder var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Button {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    headerContent
                }
                .buttonStyle(.plain)
            }
            .padding(.leading, 26)
            .padding(.trailing, 16)
            .padding(.vertical, 24)
            
            // Expandable list
            if isExpanded {
                VStack(spacing: 10) {
                    ForEach(
                        0..<totalCount, id: \.self
                    ) { index in
                        Group {
                            if index < viewModel.slaveCodeList.count {
                                CrateRow(isDetected: true, code: viewModel.slaveCodeList[index].slaveCode)
                            } else {
                                CrateRow(isDetected: false, code: "-")
                            }
                        }
                        .transition(
                            .asymmetric(
                                insertion: .opacity
                                    .combined(with: .move(edge: .top))
                                    .combined(with: .scale(scale: 0.95, anchor: .top)),
                                removal: .opacity.combined(with: .move(edge: .top))
                            )
                        )
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.75)
                            .delay(Double(index) * 0.05),
                            value: isExpanded
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.grayBackground)
        )
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder var headerContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                Text("Pengecekan Konektivitas Sensor")
                    .font(
                        .custom("Inter-Regular_Bold", size: 14)
                    )
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                
                
                Text("\(viewModel.slaveCodeList.count) / \(totalCount) Keranjang Terdeteksi")
                    .font(
                        .custom("Inter-Regular_Bold", size: 20)
                    )
                    .padding(.vertical, 10)
                    .foregroundStyle(
                        viewModel.slaveCodeList.count == totalCount ? .darkGreen : .danger
                    )
                
                if viewModel.slaveCodeList.count == totalCount {
                    Text("Status seluruh krat sudah online. Silakan memulai perjalanan.")
                        .font(
                            .custom("Inter-Regular_Light", size: 14)
                        )
                        .lineHeight(.multiple(factor: 1.55))
                        .foregroundColor(.black0D)
                } else {
                    Text("Ditemukan krat yang tidak aktif. Segera hubungi Admin Logistik sebelum melaksanakan perjalanan.")
                        .font(
                            .custom("Inter-Regular_Light", size: 14)
                        )
                        .lineHeight(.multiple(factor: 1.55))
                        .foregroundColor(.black0D)

                }
            }
            .padding(.trailing, 10)
                        
            HStack {
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isExpanded)
            }
        }
    }
}

#Preview {
    NodeSlaveDetection(
        viewModel: NodeSlaveDetectionViewModel(
            order: DeliveryOrder(
                id: 1042,
                masterCode: "m1s1",
                slaveCounts: 2,
                truckId: 1,
                originLocation: "Jakarta Warehouse A",
                destinationLocation: "Bandung Distribution Hub B",
                departureScheduledAt: Date(),
                estimatedArrivalAt: Date().addingTimeInterval(4 * 3600),
                status: "in_transit",
                createdAt: Date().addingTimeInterval(-1800),
                completedAt: nil,
                createdBy: 108
            )
        )
    )
}
