//
//  FinishScreen.swift
//  chal5-ios-app
//
//  Created by Danniel on 18/08/26.
//

import SwiftUI

struct FinishScreen: View {
    var deliveryOrder: DeliveryOrder
    
    var body: some View {
        ZStack {
            Color.veryLigthGreen.ignoresSafeArea()
            VStack (spacing: 0) {
                Header()
                FinishedStatusBar(
                    originLocation: deliveryOrder.originLocation, destinationLocation: deliveryOrder.destinationLocation, dateStart: UserDefaultRepository.shared.getOnDeliveryDate()
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                Group {
                    VStack (spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.checkmarkIcon)
                            .padding(.bottom, 20)
                    
                        Text("Tugas Selesai")
                            .font(.custom("Inter-Regular_Bold", size: 18))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            
                        Text("Silakan menghubungi Admin Logistik untuk mengonfirmasi pengiriman telah selesai.")
                            .font(.custom("Inter-Regular_Light", size: 14))
                            .foregroundStyle(Color.greyText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
            .actionFooter {
                PrimaryActionButton(title: "Kembali ke Beranda", isLoading: false) {
                    Router.shared.popToRoot()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    FinishScreen(deliveryOrder: Mock.deliveryOrder)
}
