//
//  DeliveryIncomingTest.swift
//  chal5-ios-app
//
//  Created by Danniel on 15/08/26.
//

import SwiftUI

#Preview {
    VStack {
        VStack(spacing: 16) {
            TaskCard(
                code: "BIKI-04",
                badgeText: "TUGAS BARU",
                badgeColor: .green,
                originTitle: "Kebun Mitra Sleman",
//                originSubtitle: "titik jemput",
                destinationTitle: "Lotte Mart Semarang",
//                destinationSubtitle: "tujuan akhir",
                stats: [
                    StatItem(label: "BERANGKAT", value: "06:00"),
                    StatItem(label: "ESTIMASI", value: "09:10"),
                    StatItem(label: "NODE", value: "MST-03")
                ]
            )

            InfoBanner(
                title: "SEBELUM BERANGKAT",
                message: "Sebelum melakukan keberangkatan, pastikan semua keranjang buah telah masuk ke dalam bak truk dalam posisi menyala.",
                titleColor: .brown,
                backgroundColor: Color(red: 0.98, green: 0.89, blue: 0.80)
            )
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.92, green: 0.95, blue: 0.92))
    }
}

//#Preview ("Tes") {
//    VStack {
//        RouteTimelineView(
//            originTitle: "Kebun Mitra Sleman",
//            originSubtitle: "titik jemput",
//            destinationTitle: "Lotte Mart Semarang",
//            destinationSubtitle: "tujuan akhir"
//        )
//        Spacer()
//    }
//}
