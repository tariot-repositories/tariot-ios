//
//  RootViewModel.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import Combine
import Foundation

class RootViewModel: ObservableObject {
    @Published private(set) var state: DeliveryOrderState = .idle
    
    private let repository: DeliveryOrderRepository

    init(repository: DeliveryOrderRepository = DeliveryOrderRepository()) {
        self.repository = repository
    }

    func loadActiveOrder() async {
        state = .loading
        var deliveryOrder: DeliveryOrder?
        
        do {
            deliveryOrder = try await repository.fetchActiveOrder()
        } catch {
            state = .failed(error.localizedDescription)
            return
        }
            
        guard let order = deliveryOrder else {
            state = .deliveryNotAccepted(nil)
            return
        }
        
        switch order.status {
        case "menunggu_konfirmasi_supir":
            state = .deliveryNotAccepted(order)
        case "menunggu_deteksi_node":
            state = .nodeDetectionState
        case "dalam_perjalanan":
            state = .inDeliveryState
        default:
            state = .deliveryNotAccepted(nil)
        }
    }
}

extension RootViewModel {
    enum DeliveryOrderState {
        case idle, loading, deliveryNotAccepted(DeliveryOrder?), nodeDetectionState, inDeliveryState, failed(String)
    }
}
