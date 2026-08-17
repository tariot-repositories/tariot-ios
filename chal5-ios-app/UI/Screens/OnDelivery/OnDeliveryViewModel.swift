//
//  OnDeliveryViewModel.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//

import Combine
import SwiftUI

extension AlertParameter {
    var label: String {
        switch self {
        case .temperature: return "Suhu"
        case .humidity: return "Kelembaban"
        case .ethylene: return "Gas Etilen"
        }
    }

    var unit: String {
        switch self {
        case .temperature: return "°C"
        case .humidity: return "%"
        case .ethylene: return "ppm"
        }
    }

    var tagColor: Color {
        Color(red: 0.98, green: 0.85, blue: 0.83)
    }
}

extension AlertSeverity {
    var dotColor: Color {
        switch self {
        case .critical: return Color.danger
        case .warning: return Color.orangeWarning
        }
    }
    
    var tagBgColor: Color {
        switch self {
        case .critical: return Color.infoBannerBackground
        case .warning: return Color.infoBannerBackground
        }
    }
    
    var tagTextColor: Color {
        switch self {
        case .critical: return Color.redTomato
        case .warning: return Color.redTomato
        }
    }

    var valueColor: Color {
        switch self {
        case .critical: return Color.danger
        case .warning: return Color.orangeWarning
        }
    }
}

// MARK: - ViewModel
final class AlertsViewModel: ObservableObject {
    @Published private(set) var alerts: [Alert] = []
    @Published private(set) var expandedIDs: Set<UUID> = []

    private var pollingTask: Task<Void, Never>?
    private var missCounts: [UUID: Int] = [:]
    private let maxMissesBeforeRemoval = 2

    private let api: AlertsAPIClient

    init(api: AlertsAPIClient = .init()) {
        self.api = api
    }

    func startPolling(interval: TimeInterval = 5) {
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

        for existing in alerts {
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
        next.append(contentsOf: newOnes)

        missCounts = stillMissing

        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            self.alerts = next
        }
    }
}
