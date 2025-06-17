//
//  Productivity.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Productivity.swift
// ProjectKit — Productivity lens (time tracking, KPIs).
//

import Foundation

/// Holds productivity metrics for a project.
public struct ProductivityMetrics {
    public var hoursLogged: TimeInterval
    public var tasksCompleted: Int

    public init(hoursLogged: TimeInterval = 0, tasksCompleted: Int = 0) {
        self.hoursLogged = hoursLogged
        self.tasksCompleted = tasksCompleted
    }
}

/// Actor to manage per-project productivity data.
public actor Productivity {
    private var metrics: [UUID: ProductivityMetrics] = [:]

    public init() {}

    /// Log time spent on a project.
    public func logTime(projectID: UUID, hours: TimeInterval) {
        var m = metrics[projectID] ?? ProductivityMetrics()
        m.hoursLogged += hours
        metrics[projectID] = m
    }

    /// Mark a task completed for a project.
    public func completeTask(projectID: UUID) {
        var m = metrics[projectID] ?? ProductivityMetrics()
        m.tasksCompleted += 1
        metrics[projectID] = m
    }

    /// Retrieve metrics for a project.
    public func getMetrics(for projectID: UUID) -> ProductivityMetrics {
        return metrics[projectID] ?? ProductivityMetrics()
    }
}
