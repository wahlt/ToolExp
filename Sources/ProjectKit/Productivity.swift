//
//  Productivity.swift
//  ProjectKit
//
//  Specification:
//  • Manages project productivity metrics: time spent, milestones.
//  • Interfaces with ChronosKit for timing.
//
//  Discussion:
//  Tracking durations on tasks and milestones gives insight into workflows.
//
//  Rationale:
//  • Keep timer logic in one place, separate from UI.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct Milestone {
    public let id: String
    public let title: String
    public let dueDate: Date
}

public class Productivity {
    private var milestoneTimers: [String: Date] = [:]

    /// Starts timing a milestone.
    public func start(_ m: Milestone) {
        milestoneTimers[m.id] = Date()
    }

    /// Stops timing and returns seconds spent.
    public func stop(_ m: Milestone) -> TimeInterval? {
        guard let start = milestoneTimers.removeValue(forKey: m.id) else { return nil }
        return Date().timeIntervalSince(start)
    }
}
