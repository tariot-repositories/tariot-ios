//
//  AlertMonitorWidgetLiveActivity.swift
//  AlertMonitorWidget
//
//  Created by Danniel on 20/08/26.
//
import SwiftUI
import WidgetKit
import ActivityKit

// MARK: - Attributes (sesuai yang kamu punya)

struct AlertMonitorWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var dateStarted: Date
        var message: String
    }
}

// MARK: - Tema warna (mengikuti tema "BIKI ALERT")

private extension Color {
    /// Teal-hijau khas brand, dipakai untuk eyebrow label, ikon, dan badge.
    static let bikiAccent = Color(red: 0.11, green: 0.42, blue: 0.36)
    /// Latar gelap untuk Lock Screen, senada dengan aksen brand (bukan hitam polos).
    static let bikiBackground = Color(red: 0.05, green: 0.10, blue: 0.09)
}

// MARK: - Widget

struct AlertMonitorWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlertMonitorWidgetAttributes.self) { context in
            // Tampilan Lock Screen / banner
            LiveMonitorLockScreenView(context: context)
                .activityBackgroundTint(Color.bikiBackground)
                .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded presentation
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.bikiAccent)
                        .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ElapsedBadge(dateStarted: context.state.dateStarted)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.message)
                        .font(.system(size: 13))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .padding(.top, 4)
                }
            } compactLeading: {
                Image(systemName: "bell.badge.fill")
                    .foregroundStyle(Color.bikiAccent)
            } compactTrailing: {
                Text(elapsedString(from: context.state.dateStarted))
                    .font(.caption2.monospacedDigit())
                    .fixedSize(horizontal: true, vertical: true)
                    .foregroundStyle(Color.bikiAccent)
            } minimal: {
                Image(systemName: "bell.badge.fill")
                    .foregroundStyle(Color.bikiAccent)
            }
        }
    }
}

private struct ElapsedBadge: View {
    let dateStarted: Date

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.bikiAccent)
                .frame(width: 6, height: 6)
            Text(elapsedString(from: dateStarted))
                .font(.system(size: 12, weight: .semibold).monospacedDigit())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.bikiAccent.opacity(0.14))
        .foregroundStyle(Color.bikiAccent)
        .clipShape(Capsule())
    }
}


private struct LiveMonitorLockScreenView: View {
    let context: ActivityViewContext<AlertMonitorWidgetAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("MONITORING · BIKI 4")
                    .font(.custom("Inter-Regular_Bold", size: 12))
                    .tracking(12 * 0.12)
                    .foregroundStyle(.ligthGreen)
                Spacer()
                ElapsedBadge(dateStarted: context.state.dateStarted)
            }

            Text("BIKI ALERT")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            // Kartu pesan, mirip kartu "Aman" / "Perlu Tindakan" pada mockup
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.bikiAccent)
                    .padding(.bottom, 2)

                Text(context.state.message)
                    .font(.system(size: 13))
                    .foregroundStyle(.primary)
                    .lineLimit(3)
                Spacer(minLength: 0)
            }
            .padding(12)
            .background(Color.veryLigthGreen)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(16)
    }
}

// MARK: - Helper: format elapsed time sebagai "<hh>j <mm>m"

/// Mengubah `dateStarted` menjadi durasi berlalu dalam format "2j 15m".
/// Contoh: baru mulai -> "0j 00m", sudah 1 jam 5 menit -> "1j 05m".
private func elapsedString(from dateStarted: Date) -> String {
    let elapsed = max(0, Date().timeIntervalSince(dateStarted))
    let totalMinutes = Int(elapsed) / 60
    let hours = totalMinutes / 60
    let minutes = totalMinutes % 60
    return String(format: "%dj %02dm", hours, minutes)
}

// MARK: - Sample data untuk Preview

extension AlertMonitorWidgetAttributes {
    static var preview: AlertMonitorWidgetAttributes {
        AlertMonitorWidgetAttributes()
    }
}

extension AlertMonitorWidgetAttributes.ContentState {
    static var baruMulai: AlertMonitorWidgetAttributes.ContentState {
        AlertMonitorWidgetAttributes.ContentState(
            dateStarted: Date(),
            message: "Monitoring dimulai..."
        )
    }

    static var berjalanSatuJam: AlertMonitorWidgetAttributes.ContentState {
        AlertMonitorWidgetAttributes.ContentState(
            dateStarted: Date().addingTimeInterval(-3 * 3600 - 25 * 60), // 3j 25m lalu
            message: "Semua sistem normal"
        )
    }

    static var pesanPanjang: AlertMonitorWidgetAttributes.ContentState {
        AlertMonitorWidgetAttributes.ContentState(
            dateStarted: Date().addingTimeInterval(-45 * 60), // 45m lalu
            message: "CPU usage tinggi, sedang diperiksa oleh tim monitoring"
        )
    }
}

// MARK: - Previews

#Preview("Lock Screen", as: .content, using: AlertMonitorWidgetAttributes.preview) {
    AlertMonitorWidgetLiveActivity()
} contentStates: {
    AlertMonitorWidgetAttributes.ContentState.baruMulai
    AlertMonitorWidgetAttributes.ContentState.berjalanSatuJam
    AlertMonitorWidgetAttributes.ContentState.pesanPanjang
}

#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: AlertMonitorWidgetAttributes.preview) {
    AlertMonitorWidgetLiveActivity()
} contentStates: {
    AlertMonitorWidgetAttributes.ContentState.baruMulai
    AlertMonitorWidgetAttributes.ContentState.berjalanSatuJam
}

#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: AlertMonitorWidgetAttributes.preview) {
    AlertMonitorWidgetLiveActivity()
} contentStates: {
    AlertMonitorWidgetAttributes.ContentState.berjalanSatuJam
}

#Preview("Dynamic Island Minimal", as: .dynamicIsland(.minimal), using: AlertMonitorWidgetAttributes.preview) {
    AlertMonitorWidgetLiveActivity()
} contentStates: {
    AlertMonitorWidgetAttributes.ContentState.berjalanSatuJam
}
