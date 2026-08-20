import SwiftUI
import WidgetKit
import ActivityKit

// Definisi `LiveMonitorWidgetAttributes`, `AlertLevel`, dan sample data preview
// ada di file terpisah: LiveMonitorWidgetAttributes.swift (di-share ke App + Widget
// Extension). File ini HANYA perlu tercentang di target Widget Extension.

// MARK: - Widget

struct LiveMonitorWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveMonitorWidgetAttributes.self) { context in
            // Tampilan Lock Screen / banner
            LiveMonitorLockScreenView(context: context)
                .activityBackgroundTint(Color.darkGreen)
                .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            let level = context.state.alertLevel

            return DynamicIsland {
                // Expanded presentation
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: level.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(level.tintColor)
                        .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ElapsedBadge(dateStarted: context.state.dateStarted, tintColor: level.tintColor)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(level.message(criticalCount: context.state.criticalCount, warningCount: context.state.warningCount))
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .lineLimit(2)

                        if context.state.criticalCount > 0 || context.state.warningCount > 0 {
                            HStack(spacing: 8) {
                                if context.state.criticalCount > 0 {
                                    CountChip(count: context.state.criticalCount, label: "Critical", color: .red)
                                }
                                if context.state.warningCount > 0 {
                                    CountChip(count: context.state.warningCount, label: "Warning", color: .orange)
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            } compactLeading: {
                Image(systemName: level.icon)
                    .foregroundStyle(level.tintColor)
            } compactTrailing: {
                Text(elapsedString(from: context.state.dateStarted))
                    .font(.caption2.monospacedDigit())
                    .fixedSize(horizontal: true, vertical: true)
                    .foregroundStyle(level.tintColor)
            } minimal: {
                Image(systemName: level.icon)
                    .foregroundStyle(level.tintColor)
            }
        }
    }
}

/// Badge kapsul kecil "● 2j 14m" — dipakai berulang di Lock Screen & Dynamic Island expanded.
/// `tintColor` dikirim dari luar supaya ikut warna alert level yang aktif.
private struct ElapsedBadge: View {
    let dateStarted: Date
    let tintColor: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(tintColor)
                .frame(width: 6, height: 6)
            Text(elapsedString(from: dateStarted))
                .font(.system(size: 12, weight: .semibold).monospacedDigit())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tintColor.opacity(0.14))
        .foregroundStyle(tintColor)
        .clipShape(Capsule())
    }
}

/// Chip kecil "● 1 Critical" / "● 2 Warning" — dipakai di Dynamic Island expanded
/// supaya jumlah critical/warning terlihat jelas, tidak cuma teks pesan.
private struct CountChip: View {
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text("\(count) \(label)")
                .font(.system(size: 11, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(color.opacity(0.16))
        .foregroundStyle(color)
        .clipShape(Capsule())
    }
}

// MARK: - Lock Screen view

private struct LiveMonitorLockScreenView: View {
    let context: ActivityViewContext<LiveMonitorWidgetAttributes>

    var body: some View {
        let level = context.state.alertLevel

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("MONITORING · BIKI 4")
                    .font(.custom("Inter-Regular_ExtraBold", size: 12))
                    .tracking(12 * 0.12)
                    .foregroundStyle(.ligthGreen)
                Spacer()
                ElapsedBadge(dateStarted: context.state.dateStarted, tintColor: level.tintColor)
            }

            Text("BIKI ALERT")
                .font(.custom("BricolageGrotesque-96ptExtraBold_Bold", size: 27))
                .tracking(0.05)
                .foregroundStyle(Color.black)
                .padding(.bottom, 8)

            HStack(alignment: .center, spacing: 10) {
                Image(systemName: level.icon)
                    .font(.body)
                    .foregroundStyle(level.tintColor)
                    .padding(.top, 1)
                Text(level.message(criticalCount: context.state.criticalCount, warningCount: context.state.warningCount))
                    .font(.custom("Inter-Regular_Light", size: 12))
                    .foregroundStyle(.black)
                    .lineLimit(3)
                Spacer(minLength: 0)
            }
            .padding(12)
            .background(level.tintColor.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(16)
        .background(Color.white)
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

// MARK: - Previews

#Preview("Lock Screen", as: .content, using: LiveMonitorWidgetAttributes.preview) {
    LiveMonitorWidgetLiveActivity()
} contentStates: {
    LiveMonitorWidgetAttributes.ContentState.aman
    LiveMonitorWidgetAttributes.ContentState.adaWarning
    LiveMonitorWidgetAttributes.ContentState.adaCritical
}

#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: LiveMonitorWidgetAttributes.preview) {
    LiveMonitorWidgetLiveActivity()
} contentStates: {
    LiveMonitorWidgetAttributes.ContentState.aman
    LiveMonitorWidgetAttributes.ContentState.adaWarning
    LiveMonitorWidgetAttributes.ContentState.adaCritical
}

#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: LiveMonitorWidgetAttributes.preview) {
    LiveMonitorWidgetLiveActivity()
} contentStates: {
    LiveMonitorWidgetAttributes.ContentState.aman
    LiveMonitorWidgetAttributes.ContentState.adaWarning
    LiveMonitorWidgetAttributes.ContentState.adaCritical
}

#Preview("Dynamic Island Minimal", as: .dynamicIsland(.minimal), using: LiveMonitorWidgetAttributes.preview) {
    LiveMonitorWidgetLiveActivity()
} contentStates: {
    LiveMonitorWidgetAttributes.ContentState.aman
    LiveMonitorWidgetAttributes.ContentState.adaWarning
    LiveMonitorWidgetAttributes.ContentState.adaCritical
}
