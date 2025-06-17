//
//  AutomataDSL.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AutomataDSL.swift
// EngineKit — DSL for scheduling & parsing iCal VEVENT automations.
//
// Responsibilities:
//
//  1. Provide a Swift‐native API to build one‐off and recurring reminders.
//  2. Parse raw VEVENT text into structured rule objects.
//  3. Generate next‐trigger dates from RRULEs.
//  4. Integrate with AutomationsServ for runtime scheduling.
//

import Foundation

/// A single occurrence or recurring rule for an automation.
public enum AutomationRule {
    /// A one‐time event at `date`.
    case once(date: Date, title: String)
    /// A recurring rule (RRULE) with optional EXDATEs.
    case recurring(rrule: RRule, title: String, exceptions: [Date])
}

/// Simplified model for an iCal RRULE.
public struct RRule {
    public let frequency: String       // E.g. "DAILY", "WEEKLY"
    public let interval: Int           // Repeat interval
    public let byDay: [String]?        // E.g. ["MO","WE","FR"]
    public let count: Int?             // Number of occurrences
    public let until: Date?            // End date

    public init(
        frequency: String,
        interval: Int = 1,
        byDay: [String]? = nil,
        count: Int? = nil,
        until: Date? = nil
    ) {
        self.frequency = frequency
        self.interval = interval
        self.byDay = byDay
        self.count = count
        self.until = until
    }
}

/// Entry point for Automata DSL.
public struct AutomataDSL {
    /// Build a one‐time rule.
    public static func once(on date: Date, title: String) -> AutomationRule {
        return .once(date: date, title: title)
    }

    /// Build a recurring rule.
    public static func recurring(
        frequency: String,
        interval: Int = 1,
        byDay: [String]? = nil,
        count: Int? = nil,
        until: Date? = nil,
        title: String
    ) -> AutomationRule {
        let rule = RRule(
            frequency: frequency,
            interval: interval,
            byDay: byDay,
            count: count,
            until: until
        )
        return .recurring(rrule: rule, title: title, exceptions: [])
    }

    /// Parse raw VEVENT text into `AutomationRule`s.
    public static func parse(vevent: String) throws -> [AutomationRule] {
        // TODO:
        // 1. Lex lines (BEGIN:VEVENT … END:VEVENT).
        // 2. Extract DTSTART, SUMMARY, RRULE, EXDATE.
        // 3. Return array of AutomationRule.
        return []
    }
}
