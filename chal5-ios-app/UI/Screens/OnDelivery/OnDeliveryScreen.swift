//
//  OnDeliveryView.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import SwiftUI

struct OnDeliveryView: View {
    @ObservedObject var viewModel: OnDeliveryViewModel
    
    init (viewModel: OnDeliveryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack (spacing: 0) {
            Header()
            
            OnGoingStatusBar(originLocation: viewModel.deliveryOrder.originLocation, destinationLocation: viewModel.deliveryOrder.destinationLocation, dateStart: Date.from(descriptionString: viewModel.deliveryOrder.createdAt))
                .padding(.horizontal, 20)
            
            ScrollView {
                Group {
                    if viewModel.alerts.isEmpty {
                        StatusBanner(status: .safe, updatedAt: Date.now)
                    } else {
                        StatusBanner(status: .needsAction, updatedAt: Date.now)
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal, 20)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.alerts) { alert in
                        AlertCard(
                            alert: alert,
                            isExpanded: viewModel.isExpanded(alert.id),
                            onToggle: { viewModel.toggleExpanded(alert.id) }
                        )
                        .id(alert.id)
                        .transition(
                            .asymmetric(
                                insertion: .opacity
                                    .combined(with: .move(edge: .top))
                                    .combined(with: .scale(scale: 0.96, anchor: .top)),
                                removal: .opacity.combined(with: .scale(scale: 0.9))
                            )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .scrollTargetLayout()
            }
            
            Spacer()
        }
        
        .actionFooter {
            PrimaryActionButton(
                title: "Selesaikan perjalanan", isLoading: false
            ) {
                
            }
        }
        .task {
            viewModel.startPolling()
        }
        .onDisappear {
            viewModel.stopPolling()
        }
        .background(
            Color.veryLigthGreen
        )
    }
}

#Preview {
    OnDeliveryView(viewModel:
        OnDeliveryViewModel(
            deliveryOrder: Mock.deliveryOrder
        )
    )
}
