//
//  LDRWidgetBundle.swift
//  LDRWidget
//
//  Created by Shihang Wei on 1/15/24.
//

import WidgetKit
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct LDRWidgetBundle: WidgetBundle {
    init() {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("\(TeamID).name.shihangwei.LDR")
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
    }
    
    var body: some Widget {
        LDRWidget()
    }
}
