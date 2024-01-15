//
//  LDRWidgetBundle.swift
//  LDRWidget
//
//  Created by Shihang Wei on 1/15/24.
//

import WidgetKit
import SwiftUI
import FirebaseCore

@main
struct LDRWidgetBundle: WidgetBundle {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Widget {
        LDRWidget()
    }
}
