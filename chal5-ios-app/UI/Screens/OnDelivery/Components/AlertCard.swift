//
//  AlertCard.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//
import SwiftUI

struct AlertCard: View {
    let alert: Alert
    let truckCode: String
    let thresholdLabel: String?
    let isExpanded: Bool
    let onToggle: () -> Void
    
    let unitLabel: String
    
    init (alert: Alert, truckCode: String, thresholdLabel: String? = nil, isExpanded: Bool, onToggle: @escaping () -> Void) {
        self.alert = alert
        self.truckCode = truckCode
        self.thresholdLabel = thresholdLabel
        self.isExpanded = isExpanded
        self.onToggle = onToggle
        
        switch alert.parameter {
        case .temperature:
            self.unitLabel = "°C"
        case .humidity:
            self.unitLabel = "%"
        case .ethylene:
            self.unitLabel = "ppm"
        }
    }
    
    var body: some View {
        Button(action: onToggle) {
            VStack(alignment: .leading, spacing: 14) {
                topRow
                codeRow
                
                if isExpanded {
                    expandedContent
                }
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
    }
    
    // MARK: severity, tag, times
    private var topRow: some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(alert.severity.dotColor)
                    .frame(width: 12, height: 12)
                
                Text(alert.parameter.label)
                    .font(
                        .custom("Inter-Regular_Bold", size: 14)
                    )
                    .foregroundStyle(alert.severity.tagTextColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(alert.severity.tagBgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
            
            Text("Terdeteksi \(formatTime(from: alert.readingRecordedAt))")
                .font(
                    .custom("Inter-Regular_SemiBold", size: 14)
                )
                .foregroundColor(.black)
        }
    }
    
    // MARK: Row 2 — truck code + expand/collapse chevron (always visible)
    private var codeRow: some View {
        HStack {
            Text(truckCode)
                .font(
                    .custom("Inter-Regular_Bold", size: 14)
                )
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
    }
    
    // MARK: Expanded body — value, threshold, message, action
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(String(format: "%.1f", alert.valueAtTrigger))\(unitLabel)")
                    .font(
                        .custom("Inter-Regular_Bold", size: 32)
                    )
                    .foregroundColor(alert.severity.valueColor)
                
                if let thresholdLabel {
                    Text(thresholdLabel)
                        .font(.custom("Inter-Regular_Medium", size: 14))
                        .foregroundColor(.fivetwo)
                }
            }
            
            Text(alert.message)
                .font(.custom("Inter-Regular_Medium", size: 14))
                .foregroundColor(.fivetwo)
        }
    }
}

#Preview {
    contoh()
}

struct contoh: View {
    @State var isExpandedTemp: Bool = true
    @State var isExpandedHumid: Bool = true
    @State var alert: Alert = Alert(
        id: UUID(),
        truckUUID: UUID(),
        readingID: UUID(),
        readingRecordedAt: Date(),
        parameter: .temperature,
        severity: .critical,
        valueAtTrigger: 17.3,
        message: "Suhu terlalu tinggi. Cek penutup box pendingin.",
        createdAt: Date()
    )
    
    var body: some View {
        VStack(spacing: 14) {
            AlertCard(
                alert: alert,
                truckCode: "KRT - C04",
                isExpanded: isExpandedTemp,
                onToggle: {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                        isExpandedTemp.toggle()
                    }
                }
            )
            
            AlertCard(
                alert: Alert(
                    id: UUID(),
                    truckUUID: UUID(),
                    readingID: UUID(),
                    readingRecordedAt: Date(),
                    parameter: .humidity,
                    severity: .warning,
                    valueAtTrigger: 88,
                    message: "Kelembaban di luar batas normal.",
                    createdAt: Date()
                ),
                truckCode: "KRT - C04",
                thresholdLabel: nil,
                isExpanded: isExpandedHumid,
                onToggle: {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                        isExpandedHumid.toggle()
                    }
                },
            )
        }
        .padding()
        .background(Color(uiColor: .veryLigthGreen))
    }
}

