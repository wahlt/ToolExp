// Directory: ServiceKit

//
//  AutomationsServ.swift
//  ServiceKit
//
//  Specification:
//  • High-level API for scheduling reminders and conditional alerts.
//  • Wraps UNUserNotificationCenter for local reminders.
//
//  Discussion:
//  Users need in-app reminders for deadlines or proof-check intervals.
//  This service abstracts the platform APIs to provide a simple interface.
//
//  Rationale:
//  • Encapsulate scheduling logic for portability and testability.
//  • Uses calendar-based triggers so dates are precise.
//
//  Dependencies: UserNotifications
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import UserNotifications

public class AutomationsServ {
    public static let shared = AutomationsServ()
    private init() {}

    /// Schedules a local reminder at the given date.
    public func scheduleReminder(
        id: String,
        title: String,
        body: String,
        at date: Date
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body

        let components = Calendar.current.dateComponents(
            [.year,.month,.day,.hour,.minute,.second],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )
        let req = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}

