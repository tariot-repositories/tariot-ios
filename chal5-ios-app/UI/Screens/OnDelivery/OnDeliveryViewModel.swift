//
//  OnDeliveryViewModel.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import Combine
import SwiftUI

enum FinishOnDeliveryError: LocalizedError {
    case submitFailed
    
    var errorDescription: String {
        switch self {
        default:
            return "Ups, terjadi kesalahan!"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        default:
            return "Silahkan coba lagi dalam beberapa saat"
        }
    }
}

enum OnDeliveryAlertType {
    case areYouSure
    case finishOnDeliveryError
}

// MARK: - ViewModel
final class OnDeliveryViewModel: ObservableObject {
    let activityController = LiveMonitorActivityController()
    
    @Published private(set) var alerts: [Alert] = []
    @Published private(set) var expandedIDs: Set<UUID> = []

    var deliveryOrder: DeliveryOrder
    
    private var pollingTask: Task<Void, Never>?
    private var missCounts: [UUID: Int] = [:]
    private let maxMissesBeforeRemoval = 2

    @Published var showAlert: Bool = false
    
    var alertType: OnDeliveryAlertType = .finishOnDeliveryError
    
    @Published private(set) var isFinishOnDelivery: Bool = false
    var finishOnDeliveryError: FinishOnDeliveryError = .submitFailed
    
    private let api: AlertsAPIRepository = AlertsAPIRepository.shared
    private let finishRepository: FinishDeliveryOrderRepository = FinishDeliveryOrderRepository.shared
    

    init (deliveryOrder: DeliveryOrder) {
        self.deliveryOrder = deliveryOrder
    }

    func startPolling(interval: TimeInterval = 30) {
        pollingTask?.cancel()
        pollingTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                await self.fetchAndMerge()
                try? await Task.sleep(for: .seconds(interval))
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    func isExpanded(_ id: UUID) -> Bool {
        expandedIDs.contains(id)
    }

    func toggleExpanded(_ id: UUID) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            if expandedIDs.contains(id) {
                expandedIDs.remove(id)
            } else {
                expandedIDs.insert(id)
            }
        }
    }

    func markAsChecked(_ id: UUID) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            alerts.removeAll { $0.id == id }
        }
        expandedIDs.remove(id)
        missCounts.removeValue(forKey: id)
        // TODO: panggil API untuk resolve alert di backend juga
    }

    private func fetchAndMerge() async {
        do {
            let fetched = try await api.fetchAlerts()
            merge(fetched)
        } catch {
            print("fetch alerts failed:", error)
        }
    }

    private func merge(_ fetched: [Alert]) {
        var fetchedById = Dictionary(uniqueKeysWithValues: fetched.map { ($0.id, $0) })
        var next: [Alert] = []
        var stillMissing: [UUID: Int] = [:]

        var warning: Int = 0
        var critical: Int = 0
        
        for existing in alerts {
            if existing.severity == .critical {
                critical += 1
            } else {
                warning += 1
            }
            
            if let updated = fetchedById.removeValue(forKey: existing.id) {
                next.append(updated)
            } else {
                let misses = (missCounts[existing.id] ?? 0) + 1
                if misses < maxMissesBeforeRemoval {
                    stillMissing[existing.id] = misses
                    next.append(existing)
                } else {
                    expandedIDs.remove(existing.id)
                }
            }
        }

        let newOnes = fetchedById.values.sorted { $0.createdAt < $1.createdAt }
        for newAlert in newOnes {
            if newAlert.severity == .critical {
                critical += 1
            } else {
                warning += 1
            }
        }
        
        next.append(contentsOf: newOnes)
        activityController.update(criticalCount: critical, warningCount: warning)

        missCounts = stillMissing

        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            self.alerts = next
        }
    }
}

// MARK: Finish Delivery Order
extension OnDeliveryViewModel {
    func finishDeliveryOrder() async {
        if isFinishOnDelivery {
            return
        }
        
        isFinishOnDelivery = true
        
        var newOrder: DeliveryOrder
        do {
            newOrder = try await finishRepository.finishDeliveryOrder(order: deliveryOrder)
        } catch {
            finishOnDeliveryError = .submitFailed
            
            alertType = .finishOnDeliveryError

            showAlert = true
            
            isFinishOnDelivery = false
        
            return
        }
        
        isFinishOnDelivery = false
        Router.shared.push(.complete(newOrder))
    }
}
