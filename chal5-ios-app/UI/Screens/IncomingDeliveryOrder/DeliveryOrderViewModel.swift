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
    
    private let repository: DeliveryOrderRepository

    init(repository: DeliveryOrderRepository = DeliveryOrderRepository()) {
        self.repository = repository
    }

    func loadActiveOrder() async {
        state = .loading
        do {
            state = .loaded(try await repository.fetchActiveOrder())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

extension DeliveryOrderViewModel {
    enum State {
        case idle, loading, loaded(DeliveryOrder?), failed(String)
    }
}
