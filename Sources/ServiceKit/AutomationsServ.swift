//
//  AutomationsServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AutomationsServ.swift
// ServiceKit — Manage scheduled reminders & conditional tasks via iCal VEVENT.
//
// Uses EventKit to parse/generate events or a custom VEVENT parser for in-app scheduling.
// Stores Automations in SwiftData @Model for persistence.
//

import Foundation
import EventKit
import SwiftData

/// Data model for a scheduled automation.
@Model
public class AutomationEntity {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var vevent: String  // raw iCal VEVENT string

    public init(id: UUID = .init(), title: String, vevent: String) {
        self.id = id
        self.title = title
        self.vevent = vevent
    }
}

/// Represents a single automation (reminder or conditional).
public struct Automation: Identifiable {
    public let id: UUID
    public let title: String
    public let nextTrigger: Date
    public let rawVEvent: String
}

/// Service actor for creating, updating, deleting, and executing Automations.
public actor AutomationsServ {
    private let store: ModelContext
    private let eventStore = EKEventStore()
    private var timers: [UUID: Timer] = [:]

    /// Initialize with a SwiftData context.
    public init(context: ModelContext = {
        ModelContext([AutomationEntity.self])
    }()) {
        self.store = context
    }

    /// Request permission to access reminders/calendar.
    public func requestPermissions() async throws {
        try await eventStore.requestAccess(to: .reminder)
    }

    /// Create a new automation from an iCal VEVENT.
    public func create(title: String, vevent: String) async throws -> Automation {
        // 1. Parse VEVENT to compute first `nextTrigger: Date`.
        let next = try parseNextTrigger(from: vevent)

        // 2. Persist via SwiftData.
        let entity = AutomationEntity(title: title, vevent: vevent)
        store.insert(entity)
        try store.save()

        // 3. Schedule Timer.
        schedule(entity.id, at: next)

        return Automation(id: entity.id, title: title, nextTrigger: next, rawVEvent: vevent)
    }

    /// Delete an existing automation.
    public func delete(id: UUID) async throws {
        // Cancel timer
        timers[id]?.invalidate()
        timers[id] = nil

        // Remove from store
        if let entity = try store.fetch(
            FetchDescriptor<AutomationEntity>(matching: #Predicate { $0.id == id })
        ).first {
            store.delete(entity)
            try store.save()
        }
    }

    /// List all scheduled automations.
    public func list() async throws -> [Automation] {
        let entities = try store.fetch(FetchDescriptor<AutomationEntity>())
        return try entities.map { e in
            let next = try parseNextTrigger(from: e.vevent)
            schedule(e.id, at: next)
            return Automation(id: e.id, title: e.title, nextTrigger: next, rawVEvent: e.vevent)
        }
    }

    // MARK: – Private

    /// Parse the next trigger date from an iCal VEVENT string.
    private func parseNextTrigger(from vevent: String) throws -> Date {
        // TODO: Use EventKit’s EKEvent or a custom VEVENT parser.
        // For now, schedule 1 minute from now as placeholder.
        return Date().addingTimeInterval(60)
    }

    /// Schedule a local Timer to fire the automation.
    private func schedule(_ id: UUID, at date: Date) {
        timers[id]?.invalidate()
        let interval = date.timeIntervalSinceNow
        guard interval > 0 else { return }
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            Task {
                await self.fire(id: id)
            }
        }
        timers[id] = timer
    }

    /// Called when an automation’s timer fires.
    private func fire(id: UUID) async {
        // 1. Fetch entity
        guard let entity = try? store.fetch(
            FetchDescriptor<AutomationEntity>(matching: #Predicate { $0.id == id })
        ).first else { return }

        // 2. Perform user notification or callback
        // TODO: Use UNUserNotificationCenter to deliver a local notification.

        // 3. Compute next occurrence if recurring & reschedule
        if let next = try? parseNextTrigger(from: entity.vevent) {
            schedule(id, at: next)
        }
    }
}
