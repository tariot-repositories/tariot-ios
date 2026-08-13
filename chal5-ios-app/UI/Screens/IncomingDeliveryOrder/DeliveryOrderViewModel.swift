//
//  IncomingTaskScreenm.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Combine
import Foundation


final class DeliveryOrderViewModel: ObservableObject {
    @Published private(set) var state: State = .idle
    @Published private(set) var acceptingDeliveryState: AcceptingDeliverState = .idle

    private let repository: DeliveryOrderRepository

    init(repository: DeliveryOrderRepository = DeliveryOrderRepository()) {
        self.repository = repository
    }

    func loadActiveOrder() async {
        var deliveryOrder: DeliveryOrder?
        state = .loading
        
        do {
            deliveryOrder = try await repository.fetchActiveOrder()
        } catch {
            state = .failed(error.localizedDescription)
            return
        }
        
        guard let order = deliveryOrder else {
            state = .loaded(nil)
            return
        }
        
        switch order.status {
        case "menunggu_konfirmasi_supir":
            state = .loaded(order)
        default:
            state = .failed("Order Status doesn't match")
        }
        
    }
    
    func acceptActiveOrder(order: DeliveryOrder) async {
        guard case .loaded = state else {
            print("State is NOT loaded.")
            return
        }
        
        acceptingDeliveryState = .acceptingDeliverOrder
        
        do {
            try await repository.acceptActiveOrder(order: order)
        } catch {
            acceptingDeliveryState = .failed(error.localizedDescription)
            return
        }
        
        acceptingDeliveryState = .detectionNodePhase(order)
    }
}

extension DeliveryOrderViewModel {
    enum State {
        case idle
        case loading
        case loaded(DeliveryOrder?)
        case failed(String)
    }
    
    enum AcceptingDeliverState: Equatable {
        case idle
        case acceptingDeliverOrder
        case detectionNodePhase(DeliveryOrder)
        case failed(String)
    }
}
