//
//  AppleKitAdaptor.swift
//  IntegrationKit
//
//  Specification:
//  • Bridges Tool to native Apple services: Shortcuts, Handoff, Notifications.
//  • Wraps calls in safe API for availability checks.
//
//  Discussion:
//  To integrate with Shortcuts and Handoff, we need a thin layer
//  that hides iOS version checks and entitlement requirements.
//
//  Rationale:
//  • Prevent compile-time errors when using newer APIs.
//  • Provide fallbacks or no-ops on unsupported OS versions.
//  Dependencies: UIKit, Intents, UserNotifications
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import UIKit
import Intents
import UserNotifications

public enum AppleKitAdaptor {
    /// Registers a Shortcut intent from an INIntent.
    public static func registerShortcut(_ intent: INIntent) {
        if #available(iOS 16, *) {
            let shortcut = INShortcut(intent: intent)
            let interaction = INInteraction(shortcut: shortcut, intentResponse: nil)
            interaction.donate(completion: nil)
        }
    }

    /// Handoff user activity continuation.
    public static func continueUserActivity(_ activity: NSUserActivity) {
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil) { error in
            if let err = error {
                print("Handoff failed:", err)
            }
        }
    }

    /// Schedules a local notification.
    public static func scheduleNotification(title: String, body: String, after sec: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title; content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: sec, repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}
