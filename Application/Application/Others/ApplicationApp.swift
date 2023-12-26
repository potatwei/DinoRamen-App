//
//  ApplicationApp.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI
import SwiftData
import FirebaseCore



@main
struct ApplicationApp: App {
    init() {
        FirebaseApp.configure()
    }
    @State private var interface = MainInterfaceViewModel() // interface instance
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainInterfaceView(interface: interface)
        }
        .modelContainer(sharedModelContainer)
    }
}
