//
//  ApplicationApp.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import WidgetKit

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("\(TeamID).name.shihangwei.LDR")
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("fcm", fcm)
        }
    }
}

@main
struct ApplicationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    var notificationManager = NotificationManager()
    
    init () {}
    
    var body: some Scene {
        WindowGroup {
            MainInterfaceView()
                .onChange(of: scenePhase) { oldValue, newValue in
                    if newValue == .inactive {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
                .task {
                    print("+++++++++==========")
                    await notificationManager.getAuthStatus()
                    if !notificationManager.hasPermission {
                        await notificationManager.request()
                        print("==========+++++++++")
                    }
                }
        }
    }
}
