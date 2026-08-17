//
//  StatusBar.swift
//  chal5-ios-app
//
//  Created by Danniel on 16/08/26.
//

import SwiftUI

struct OnGoingStatusBar : View {
    let dateStart: Date
    let originLocation: String
    let destinationLocation: String
    
    @State private var elapsedTimeText: String = ""

    init(originLocation: String, destinationLocation: String, dateStart: Date) {
        self.originLocation = trucatedString(originalText: originLocation, limit: 10)
        self.destinationLocation = trucatedString(originalText: destinationLocation, limit: 10)
        self.dateStart = dateStart
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(originLocation) -> \(destinationLocation)")
                    .font(
                        .custom("Inter-Regular_Medium", size: 12)
                    )
                    .foregroundStyle(.greyText)
                
                Text("Berjalan \(elapsedTimeText)")
                    .font(.custom("BricolageGrotesque-96ptExtraBold_Bold", size: 15))
                    .tracking(0.05)
                    .foregroundStyle(Color.black)
            }

            Spacer()

            StatusBadge(text: "ON TRACK", color: .green, background: .green.opacity(0.15))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .background(.white)
        .frame(maxWidth: .infinity) // Diperbaiki dari width: .infinity agar aman
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .border(Color.cardOrder, width: 1)
        .shadow(color: Color.shadow, radius: 18, y: 6)
        .padding(.horizontal, 20)
        .task {
            calculateElapsedTime()
            
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 60_000_000_000)
                calculateElapsedTime()
            }
        }
    }

    private func calculateElapsedTime() {
        let diffInSeconds = Date().timeIntervalSince(dateStart)
        let totalMinutes = max(0, Int(diffInSeconds / 60))
        
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            if minutes > 0 {
                elapsedTimeText = "\(hours)j \(minutes)m"
            } else {
                elapsedTimeText = "\(hours)j"
            }
        } else {
            elapsedTimeText = "\(minutes)m"
        }
    }
}

#Preview ("On Going Status Bar"){
    ZStack {
        Color.veryLigthGreen.edgesIgnoringSafeArea(.all)

        VStack {
            let pastDate = Calendar.current.date(byAdding: .minute, value: -75, to: Date())!
            OnGoingStatusBar(originLocation: "Kebun Mitra Sleman", destinationLocation: "Lotte Mart Semarang", dateStart: pastDate)
        }
    }
}
