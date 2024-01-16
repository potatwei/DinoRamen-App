//
//  ApplicationApp.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import WidgetKit

@main
struct ApplicationApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    init () {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("\(TeamID).name.shihangwei.LDR")
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainInterfaceView()
                .onChange(of: scenePhase) { oldValue, newValue in
                    if newValue == .inactive {
                        WidgetCenter.shared.reloadAllTimelines()
                        
                    }
                }
        }
    }
}
