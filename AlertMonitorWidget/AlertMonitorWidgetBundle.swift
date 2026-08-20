//
//  AlertMonitorWidgetBundle.swift
//  AlertMonitorWidget
//
//  Created by Danniel on 20/08/26.
//

import WidgetKit
import SwiftUI

@main
struct AlertMonitorWidgetBundle: WidgetBundle {
    var body: some Widget {
        AlertMonitorWidget()
        AlertMonitorWidgetLiveActivity()
    }
}
