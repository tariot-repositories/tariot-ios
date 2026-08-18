//
//  RootViewModel.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import Combine
import Foundation

class RootViewModel: ObservableObject {
    @Published private(set) var state: DeliveryOrderState = .loading
    
    private let repository: DeliveryOrderRepository = DeliveryOrderRepository.shared
    
    var deliveryOrder: DeliveryOrder?

    func refreshUntilGetActiveOrder() async {
        var isFirstTime: Bool = false
        var response: DeliveryOrder?
        
        while true {
            do {
                if isFirstTime {
                    try await Task.sleep(for: .seconds(5))
                }
                isFirstTime = true

                response = try await repository.fetchActiveOrder()
                
                break
            } catch {
                continue
            }
        }
            
        guard let order = response else {
            state = .noDelivery
            return
        }
        
        self.deliveryOrder = order
        
        switch order.status {
        case .menungguKonfirmasiSupir:
            state = .deliveryNotAccepted
        case .menungguDeteksiNode:
            state = .nodeDetectionState
        case .dalamPerjalanan:
            state = .inDeliveryState
        default:
            state = .noDelivery
        }
    }
}

extension RootViewModel {
    enum DeliveryOrderState {
        case loading, noDelivery, deliveryNotAccepted, nodeDetectionState, inDeliveryState
    }
}
