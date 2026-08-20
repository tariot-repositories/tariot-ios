//
//  LiveMonitorWidgetBundle.swift
//  LiveMonitorWidget
//
//  Created by Danniel on 20/08/26.
//

import WidgetKit
import SwiftUI

@main
struct LiveMonitorWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveMonitorWidget()
        LiveMonitorWidgetLiveActivity()
    }
}
