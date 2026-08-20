//
//  LiveMonitorActivityController.swift
//  chal5-ios-app
//
//  Created by Danniel on 20/08/26.
//


import Foundation
import ActivityKit

/// Dipanggil dari App target (bukan widget extension) — mengelola start/update/end
/// Live Activity `LiveMonitorWidgetAttributes` yang sudah kita bikin.
@Observable
class LiveMonitorActivityController {
    private(set) var activity: Activity<LiveMonitorWidgetAttributes>?

    /// Panggil ini untuk MENGAKTIFKAN Live Activity-nya (mulai muncul di Lock Screen /
    /// Dynamic Island). Wajib dipanggil saat app sedang foreground.
    func start(criticalCount: Int = 0, warningCount: Int = 0) {
        // 1. Pastikan Live Activity diizinkan (lihat pembahasan sebelumnya soal
        //    areActivitiesEnabled — tidak ada alert permission, cuma dicek saja).
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities dimatikan untuk app ini di Settings.")
            return
        }

        // 2. Kalau sudah ada activity yang jalan, jangan start baru lagi.
        guard activity == nil else {
            print("Live Activity sudah aktif, pakai update() bukan start() lagi.")
            return
        }

        let attributes = LiveMonitorWidgetAttributes() // atributes-mu memang kosong
        let initialState = LiveMonitorWidgetAttributes.ContentState(
            criticalCount: criticalCount,
            warningCount: warningCount,
            dateStarted: Date()
        )

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: initialState, staleDate: nil),
                pushType: nil // murni lokal, tanpa push notification
            )
            print("Live Activity aktif dengan id: \(activity?.id ?? "-")")
        } catch {
            print("Gagal mengaktifkan Live Activity: \(error)")
        }
    }

    /// Panggil setiap kali criticalCount/warningCount berubah (misal dari hasil
    /// polling sensor, WebSocket, dsb). dateStarted tetap dipertahankan dari activity
    /// yang sedang berjalan supaya elapsed time-nya tidak reset.
    func update(criticalCount: Int, warningCount: Int) {
        guard let activity else { return }

        let newState = LiveMonitorWidgetAttributes.ContentState(
            criticalCount: criticalCount,
            warningCount: warningCount,
            dateStarted: activity.content.state.dateStarted
        )

        Task {
            await activity.update(ActivityContent(state: newState, staleDate: nil))
        }
    }

    /// Panggil saat task/monitoring selesai — Live Activity tidak otomatis hilang
    /// sendiri (lihat pembahasan sebelumnya), jadi ini wajib dipanggil eksplisit.
    func end() {
        guard let activity else { return }

        Task {
            await activity.end(
                ActivityContent(state: activity.content.state, staleDate: nil),
                dismissalPolicy: .default
            )
            self.activity = nil
        }
    }

    /// Panggil saat app baru dibuka (launch/foreground) untuk sinkronkan ulang
    /// referensi `activity` kalau ternyata sudah ada Live Activity yang berjalan
    /// dari sesi sebelumnya (misalnya app sempat di-force-quit).
    func reconcileExistingActivities() {
        if let existing = Activity<LiveMonitorWidgetAttributes>.activities.first {
            self.activity = existing
        }
    }
}
