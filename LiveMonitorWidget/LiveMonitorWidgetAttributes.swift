//
//  LiveMonitorWidgetAttributes.swift
//  chal5-ios-app
//
//  Created by Danniel on 20/08/26.
//


import Foundation
import ActivityKit
import SwiftUI

// ⚠️ File ini WAJIB di-share ke DUA target: App iOS-mu DAN Widget Extension.
// Cek di File Inspector (⌥⌘1) kolom "Target Membership" — keduanya harus tercentang.
// Alasannya: App butuh `LiveMonitorWidgetAttributes` untuk memanggil Activity.request,
// sedangkan Widget Extension butuh tipe yang sama persis untuk menggambar UI-nya.

// MARK: - Attributes

struct LiveMonitorWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var criticalCount: Int
        var warningCount: Int
        var dateStarted: Date
    }
}

// MARK: - Konfigurasi Alert Level — EDIT DI SINI

// Ini satu-satunya tempat yang perlu kamu ubah untuk atur:
// 1) kapan status jadi warning / critical (Threshold),
// 2) warna & ikon tiap status,
// 3) teks pesan tiap status.
// Semua view di Widget Extension otomatis mengikuti ini.

enum AlertLevel {
    case safe
    case warning
    case critical

    /// Ambang batas jumlah critical/warning. Urutan pengecekan: critical duluan,
    /// baru warning — jadi kalau keduanya kepenuhi, yang menang adalah critical.
    private enum Threshold {
        static let critical = 2   // criticalCount >= 1 -> merah
        static let warning = 2    // warningCount >= 1 (dan critical belum kena) -> oranye
    }

    static func evaluate(criticalCount: Int, warningCount: Int) -> AlertLevel {
        if criticalCount >= Threshold.critical {
            return .critical
        } else if warningCount >= Threshold.warning {
            return .warning
        } else {
            return .safe
        }
    }

    /// Warna aksen: dipakai untuk ikon, badge waktu, dan tint kartu pesan.
    var tintColor: Color {
        switch self {
        case .safe:     return Color.green
        case .warning:  return Color.orange
        case .critical: return Color.red
        }
    }

    /// Ikon SF Symbol tiap status.
    var icon: String {
        switch self {
        case .safe:     return "checkmark.seal.fill"
        case .warning:  return "exclamationmark.triangle.fill"
        case .critical: return "exclamationmark.octagon.fill"
        }
    }

    /// Pesan yang tampil di kartu. Boleh diubah bebas, termasuk dibuat pakai
    /// angka criticalCount/warningCount seperti contoh di bawah.
    func message(criticalCount: Int, warningCount: Int) -> String {
        switch self {
        case .safe:
            return "Semua sistem normal"
        case .warning:
            return "\(warningCount) peringatan terdeteksi, mohon dicek"
        case .critical:
            return "\(criticalCount) kondisi kritis! Segera tindak lanjuti"
        }
    }
}

extension LiveMonitorWidgetAttributes.ContentState {
    /// Status alert dihitung otomatis dari criticalCount & warningCount — tidak perlu
    /// dikirim manual dari app, cukup update criticalCount/warningCount saja.
    var alertLevel: AlertLevel {
        AlertLevel.evaluate(criticalCount: criticalCount, warningCount: warningCount)
    }
}

// MARK: - Sample data untuk Preview (dipakai widget extension, aman ikut di-compile App juga)

extension LiveMonitorWidgetAttributes {
    static var preview: LiveMonitorWidgetAttributes {
        LiveMonitorWidgetAttributes()
    }
}

extension LiveMonitorWidgetAttributes.ContentState {
    static var aman: LiveMonitorWidgetAttributes.ContentState {
        LiveMonitorWidgetAttributes.ContentState(
            criticalCount: 0,
            warningCount: 0,
            dateStarted: Date().addingTimeInterval(-3 * 3600 - 25 * 60) // 3j 25m lalu
        )
    }

    static var adaWarning: LiveMonitorWidgetAttributes.ContentState {
        LiveMonitorWidgetAttributes.ContentState(
            criticalCount: 0,
            warningCount: 2,
            dateStarted: Date().addingTimeInterval(-45 * 60) // 45m lalu
        )
    }

    static var adaCritical: LiveMonitorWidgetAttributes.ContentState {
        LiveMonitorWidgetAttributes.ContentState(
            criticalCount: 1,
            warningCount: 2,
            dateStarted: Date().addingTimeInterval(-10 * 60) // 10m lalu
        )
    }
}
