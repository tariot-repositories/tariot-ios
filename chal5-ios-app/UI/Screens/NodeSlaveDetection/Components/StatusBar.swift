//
//  StatusBar.swift
//  chal5-ios-app
//
//  Created by Danniel on 17/08/26.
//


//
//  StatusBar.swift
//  chal5-ios-app
//
//  Created by Danniel on 16/08/26.
//

import SwiftUI

struct StatusBar : View {
    var dateStart: String
    var originLocation: String
    var destinationLocation: String
    
    init (originLocation: String, destinationLocation: String, dateStart: Date) {
        self.originLocation = trucatedString(originalText: originLocation, limit: 10)
        self.destinationLocation = trucatedString(originalText: destinationLocation, limit: 10)
        self.dateStart = formatTime(from: dateStart)
    }
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 2) {
                Text("\(originLocation) -> \(destinationLocation)")
                    .font(
                        .custom("Inter-Regular_Medium", size: 12)
                    )
                    .foregroundStyle(.greyText) 
                Text("Jadwal \(dateStart)")
                    .font(.custom("BricolageGrotesque-96ptExtraBold_Bold", size: 15))
                    .tracking(0.05)
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
            
            StatusBadge(text: "BELUM JALAN", color: Color.darkGrey, background: .waitingBikiButton)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
        .background(.white)
        .frame(width: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .border(Color.cardOrder, width: 1)
        .shadow(color: Color.shadow, radius: 18, y: 6)
        .padding(.horizontal, 20)
    }
}

#Preview ("Status Bar"){
    ZStack {
        Color.veryLigthGreen.edgesIgnoringSafeArea(.all)
        
        VStack {
            StatusBar(originLocation: "Kebun Mitra Sleman", destinationLocation: "Lotte Mart Semarang", dateStart: Date.now)
        }
    }
}