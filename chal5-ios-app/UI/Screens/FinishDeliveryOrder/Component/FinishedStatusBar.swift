//
//  StatusBar.swift
//  chal5-ios-app
//
//  Created by Danniel on 16/08/26.
//

import SwiftUI

struct FinishedStatusBar : View {
    let dateStart: Date
    let originLocation: String
    let destinationLocation: String
    
    private var elapsedTimeText: String
    
    init(originLocation: String, destinationLocation: String, dateStart: Date) {
        self.originLocation = trucatedString(originalText: originLocation, limit: 10)
        self.destinationLocation = trucatedString(originalText: destinationLocation, limit: 10)
        self.dateStart = dateStart
        
        self.elapsedTimeText = calculateElapsedTime(dateStart: dateStart)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(originLocation) -> \(destinationLocation)")
                    .font(
                        .custom("Inter-Regular_Medium", size: 12)
                    )
                    .foregroundStyle(.greyText)
                
                Text("Sampai · Aktual \(elapsedTimeText)")
                    .font(.custom("BricolageGrotesque-96ptExtraBold_Bold", size: 15))
                    .tracking(0.05)
                    .foregroundStyle(Color.black)
            }

            Spacer()

            StatusBadge(text: "SELESAI", color: .green, background: .green.opacity(0.15))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .background(.white)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .border(Color.cardOrder, width: 1)
        .shadow(color: Color.shadow, radius: 18, y: 6)
    }
}

#Preview ("On Going Status Bar"){
    ZStack {
        Color.veryLigthGreen.edgesIgnoringSafeArea(.all)

        VStack {
            FinishedStatusBar(originLocation: "Kebun Mitra Sleman", destinationLocation: "Lotte Mart Semarang", dateStart: UserDefaultRepository.shared.getOnDeliveryDate())
        }
    }
}
