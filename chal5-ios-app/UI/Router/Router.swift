//
//  AppRouter.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI
import Combine

enum Route: Hashable {
    case nodeDetection(DeliveryOrder)
    case inDelivery(DeliveryOrder)
    case complete(DeliveryOrder)
}


final class Router: ObservableObject {
    static let shared = Router()
    
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path.removeLast(path.count)
        }
    }
}

struct RouteDestinationView: View {
    let route: Route
    
    var body: some View {
        switch route {
        case .nodeDetection(let order):
            NodeSlaveDetection(
                viewModel: NodeSlaveDetectionViewModel(order: order)
            )
        case .inDelivery(let order):
            OnDeliveryView(
                viewModel: OnDeliveryViewModel(deliveryOrder: order)
            ).task {
                UserDefaultRepository.shared.setOnDeliveryDate(Date.now)
            }
        case .complete(let order):
            FinishScreen(deliveryOrder: order)
        }
    }
}
