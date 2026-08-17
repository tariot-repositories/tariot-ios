//
//  IncomingTaskScreenm.swift
//  chal5-ios-app
//
//  Created by Danniel on 12/08/26.
//

import Combine
import Foundation

enum AcceptingDeliverError: LocalizedError {
    case noDeliveryOrder
    case submitFailed
    
    var errorDescription: String {
        switch self {
        case .noDeliveryOrder:
            return "Tidak ada pesanan yang bisa diterima"
        default:
            return "Ups, terjadi kesalahan!"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .noDeliveryOrder:
            return "Silahkan coba lagi ketika sudah ada pesanan masuk"
        default:
            return "Silahkan coba lagi dalam beberapa saat"
        }
    }
}

final class DeliveryOrderViewModel: ObservableObject {
    @Published private(set) var state: DeliveryOrderState
    
    @Published private(set) var isAcceptingDelivery: Bool = false
    @Published var isAcceptingDeliveryError: Bool = false
    var acceptingDeliveryError: AcceptingDeliverError? = nil
    
    private let repository: DeliveryOrderRepository = DeliveryOrderRepository.shared
    
    var deliveryOrder: DeliveryOrder?

    init(deliveryOrder: DeliveryOrder?) {
        self.deliveryOrder = deliveryOrder
        
        if deliveryOrder == nil {
            self.state = .loadedButEmpty
        } else {
            self.state = .loaded
        }
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
        
        let activeOrder: DeliveryOrder = response!
        self.deliveryOrder = activeOrder
        state = .loaded
        
        switch activeOrder.status {
        case "menunggu_deteksi_node":
            Router.shared.push(.nodeDetection(activeOrder))
        case "dalam_perjalanan":
            Router.shared.push(.inDelivery(activeOrder))
        default:
            break
        }
        
    }
    
    func acceptActiveOrder() async {
        if isAcceptingDelivery {
            return
        }
        
        isAcceptingDelivery = true
        
        guard let order = deliveryOrder else {
            isAcceptingDeliveryError = true
            acceptingDeliveryError = .noDeliveryOrder
            isAcceptingDelivery = false
            return
        }
        
        guard case .loaded = state else {
            isAcceptingDeliveryError = true
            acceptingDeliveryError = .noDeliveryOrder
            isAcceptingDelivery = false
            return
        }
        
        do {
            try await repository.acceptActiveOrder(order: order)
            isAcceptingDelivery = false
        } catch {
            isAcceptingDeliveryError = true
            acceptingDeliveryError = .submitFailed
            isAcceptingDelivery = false
            return
        }
        
        Router.shared.push(.nodeDetection(order))
    }
}

extension DeliveryOrderViewModel {
    enum DeliveryOrderState {
        case loadedButEmpty
        case loaded
    }
}
