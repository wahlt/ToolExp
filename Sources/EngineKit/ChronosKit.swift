//
//  ChronosKit.swift
//  EngineKit
//
//  Specification:
//  • Utilities for time-based workflows: scheduling, delays, timers.
//  • Provides human-readable formatting and time interval calculations.
//
//  Discussion:
//  Many Kit workflows need to measure durations (gesture time windows Z),
//  schedule retries (AI backoff), or timestamp events (analytics).
//
//  Rationale:
//  • Centralize all time/date logic to avoid drift and inconsistent formats.
//  • Leverage Foundation’s Date, Calendar, DateComponents for reliability.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum ChronosKit {
    /// Returns a Date after adding the specified interval to now.
    public static func after(seconds: TimeInterval) -> Date {
        return Date().addingTimeInterval(seconds)
    }

    /// Formats a Date into a localized, human-readable string.
    public static func formatted(_ date: Date, style: DateFormatter.Style = .short) -> String {
        let df = DateFormatter()
        df.dateStyle = style
        df.timeStyle = style
        return df.string(from: date)
    }

    /// Executes a closure after a delay on the main queue.
    public static func delay(_ seconds: TimeInterval, execute block: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: block)
    }

    /// Measures execution time of a closure, returning the result and elapsed seconds.
    @discardableResult
    public static func measure<T>(_ label: String = "", _ block: () throws -> T) rethrows -> (result: T, duration: TimeInterval) {
        let start = Date()
        let value = try block()
        let elapsed = Date().timeIntervalSince(start)
        if !label.isEmpty { print("[ChronosKit] \(label) took \(elapsed)s") }
        return (value, elapsed)
    }
}
