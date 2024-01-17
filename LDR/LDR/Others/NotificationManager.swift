//
//  NotificationManager.swift
//  LDR
//
//  Created by Shihang Wei on 1/16/24.
//

import Foundation
import UserNotifications

@Observable
class NotificationManager{
    private(set) var hasPermission = false
    
    init() {
        Task {
            await getAuthStatus()
        }
    }
    
    @MainActor
    func request() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await getAuthStatus()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case . authorized, .ephemeral, .provisional:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}
