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
    case complete
}


final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
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
        case .inDelivery(_):
            EmptyView()
        case .complete:
            EmptyView()
        }
    }
}
