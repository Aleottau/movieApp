//
//  NotificationManager.swift
//  inhouseApp1
//
//  Created by alejandro on 11/11/22.
//

import Foundation
import UserNotifications
import UIKit
protocol NotificationManagerProtocol {
    func registerRemoteNot()
}
class NotificationManager: NSObject {
    let uiApp: UIApplication
    let notCenter: UNUserNotificationCenter
    init(uiApp: UIApplication = .shared, notCenter: UNUserNotificationCenter = .current()) {
        self.uiApp = uiApp
        self.notCenter = notCenter
    }
}

extension NotificationManager: NotificationManagerProtocol {
    func registerRemoteNot() {
        notCenter.delegate = self
        notCenter.requestAuthorization(options: [.alert,.badge,.sound]) { authorized, error in
            guard error == nil else {
                print(error ?? "error")
                return
            }
            guard authorized else {
                print("no authorized")
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.uiApp.registerForRemoteNotifications()
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // swiftlint: disable line_length
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler([.sound,.badge,.banner])
    }
}
