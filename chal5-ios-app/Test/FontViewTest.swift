//
//  FontView.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

import SwiftUI

struct FontViewTest : View {
    var body: some View {
        Text("BIKI-04")
            .font(.custom("BricolageGrotesque-96ptExtraBold_Bold", size: 24))
            .tracking(24 * (-8 / 100))
    }
}

#Preview {
    FontViewTest()
}
