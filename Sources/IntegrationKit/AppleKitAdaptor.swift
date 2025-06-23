// File: Sources/IntegrationKit/AppleKitAdaptor.swift
//  IntegrationKit
//
//  Specification:
//  • Adapts native AppleKit frameworks (Intents, Notifications) for ToolExp.
//  • UIKit usage is guarded so the module still builds on non-UIKit platforms.
//
//  Discussion:
//  Uses `#if canImport(UIKit)` to conditionally import and reference
//  UIKit types without breaking macOS or visionOS builds.
//
//  Rationale:
//  • Supports Siri/Shortcut integrations on iOS.
//  • Maintains cross-platform compatibility in the package.
//
//  TODO:
//  • Implement actual intent handlers and notification scheduling.
//  • Add unit tests for intent responses.
//
//  Dependencies: Foundation, Intents, UserNotifications, UIKit (optional)
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import Intents
import UserNotifications

public struct AppleKitAdaptor {
    public init() {}

    #if canImport(UIKit)
    /// Presents a quick action banner using UIKit.
    public func showBanner(title: String, subtitle: String?) {
        // TODO: implement using UIApplication.shared.keyWindow…
    }
    #endif

    /// Schedules a simple local notification.
    public func scheduleNotification(
        title: String, body: String, after seconds: TimeInterval
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: seconds, repeats: false
        )
        let req = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req)
    }
}
