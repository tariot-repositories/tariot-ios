//
//  RouteTimeLine.swift
//  chal5-ios-app
//
//  Created by Danniel on 15/08/26.
//
import SwiftUI

struct RouteTimelineView: View {
    let originTitle: String
    let destinationTitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .strokeBorder(Color.secondary, lineWidth: 2)
                    .frame(width: 14, height: 14)
                    .padding(.top, 12)
                
                Rectangle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 4)
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 14, height: 14)
                    .padding(.bottom, 12)
            }
            .frame(width: 14)

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(originTitle).font(
                        .custom("Inter-Regular_Bold", size: 15)
                    )
                    .foregroundStyle(.black)
                    Text("titik jemput").font(
                        .custom("Inter-Regular_Medium", size: 11)
                    )
                    .foregroundStyle(.greyText)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(destinationTitle).font(
                        .custom("Inter-Regular_Bold", size: 15)
                    )
                    .foregroundStyle(.black)
                    Text("tujuan akhir").font(
                        .custom("Inter-Regular_Medium", size: 11)
                    )
                    .foregroundStyle(.greyText)
                }
            }
        }
        
        .fixedSize(horizontal: false, vertical: true)
    }
}
