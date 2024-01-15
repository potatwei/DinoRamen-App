//
//  ApplicationApp.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct ApplicationApp: App {
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
        }
    }
}
