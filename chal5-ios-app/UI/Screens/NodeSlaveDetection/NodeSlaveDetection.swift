//
//  NodeSlaveDetection.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import SwiftUI

struct NodeSlaveDetection: View {
    @ObservedObject var viewModel: NodeSlaveDetectionViewModel
    
    init(viewModel: NodeSlaveDetectionViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            VStack {
                List(viewModel.slaveCodeList.enumerated(), id: \.offset) { _, code in
                    Text(code.slaveCode)
                }
                
                if viewModel.decodeError != nil {
                    Text(viewModel.decodeError!)
                }
                
                if viewModel.isListening {
                    Text("Listening..")
                } else {
                    Text("Not Listening..")
                }
                
                Button ("Start Listening") {
                    Task {
                        await viewModel.start(base_topic: viewModel.deliveryOrder.masterCode)
                    }
                }
                
                Button ("Stop Listening") {
                    viewModel.stop()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
