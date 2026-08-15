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
    
    private let repository: DeliveryOrderRepository
    
    var deliveryOrder: DeliveryOrder?
    
    init(repository: DeliveryOrderRepository = DeliveryOrderRepository()) {
        self.repository = repository
    }

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
                
                guard let _ = response else {
                    continue
                }
                
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
        case "menunggu_konfirmasi_supir":
            state = .deliveryNotAccepted
        case "menunggu_deteksi_node":
            state = .nodeDetectionState
        case "dalam_perjalanan":
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
