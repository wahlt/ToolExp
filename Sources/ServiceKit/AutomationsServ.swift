//
//  AutomationsServ.swift
//  ServiceKit
//
//  1. Purpose
//     Schedules local reminders and notifications for ToolExp tasks.
// 2. Dependencies
//     Foundation, UserNotifications
// 3. Overview
//     Wraps UNUserNotificationCenter to request permission and schedule
//     one-off or repeating notifications.
// 4. Usage
//     AutomationsServ.shared.schedule(
//       title: "Reminder",
//       body: "Do the thing",
//       date: someDate,
//       repeats: false
//     )
// 5. Notes
//     Uses badge count for pending reminders; can be extended for actions.

import Foundation
import UserNotifications

public final class AutomationsServ {
    public static let shared = AutomationsServ()
    private init() {}

    /// Requests user permission for notifications (badge, alert, sound).
    public func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
        let opts: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: opts, completionHandler: completion)
    }

    /// Schedules a local notification.
    ///
    /// - Parameters:
    ///   - title: The notification title.
    ///   - body:  The notification body text.
    ///   - date:  The first fire date.
    ///   - repeats: Whether to repeat at the same interval.
    public func schedule(
        title: String,
        body: String,
        date: Date,
        repeats: Bool = false
    ) {
        // Build content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        content.sound = .default
        // Trigger
        let comps = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: repeats)
        // Request
        let req = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req) { error in
            if let e = error {
                print("AutomationsServ: failed to schedule: \(e)")
            }
        }
    }

    /// Cancels all pending notifications.
    public func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
