//
//  MetricCollector.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// MetricCollector.swift
// InvestigateKit — Performance metrics & profiling using os_signpost.
//
// Use this to instrument your code paths (e.g. MechEng steps, ML passes).
//

import Foundation
import os.signpost

/// Central collector for performance metrics.
public final class MetricCollector {
    /// Shared singleton instance.
    public static let shared = MetricCollector()

    private let log: OSLog
    private let signposter: OSSignposter

    private init() {
        // Subsystem should match your app’s bundle ID
        log = OSLog(subsystem: "com.yourcompany.Tool", category: "InvestigateKit")
        signposter = OSSignposter(log: log)
    }

    /// Begin a timing interval for a given name.
    /// - Returns: a session handle you must pass to `end(_:)`.
    @discardableResult
    public func startInterval(_ name: StaticString) -> OSSignposter.Session {
        return signposter.beginInterval(name: name)
    }

    /// End a previously begun timing interval.
    /// - Parameter session: the session returned from `startInterval(_:)`.
    public func endInterval(_ session: OSSignposter.Session, name: StaticString) {
        signposter.endInterval(name: name, session: session)
    }

    /// Record an instantaneous event or gauge.
    /// - Parameters:
    ///   - name: identifier for the metric.
    ///   - value: numeric value to log.
    public func recordEvent(_ name: StaticString, value: Double) {
        os_signpost(.event, log: log, name: name, "%{public}.2f", value)
    }
}
