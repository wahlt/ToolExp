// File: Sources/ProjectKit/Projects.swift
//  ProjectKit
//
//  Specification:
//  • Model for a user project, conforming to `Persistable`.
//  • Minimal stub to demonstrate DataServ integration.
//
//  Discussion:
//  `Project` holds basic metadata (ID + name).
//  Actual `save()` / `loadAll()` implementations live in DataServ.
//
//  Rationale:
//  • Illustrates how business models import and use the DataServ protocol.
//  • Keeps model code clean of storage details.
//
//  TODO:
//  • Add thumbnail, lastUpdated, tags, and other fields.
//  • Implement versioned migrations when loading older data.
//
//  Dependencies: Foundation, DataServ
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import DataServ

public struct Project: Persistable, Sendable {
    /// Unique identifier for this project
    public let id: UUID
    /// Human‐readable name
    public var name: String

    /// Designated initializer
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    /// Persistable conformance: forwarded to DataServ implementation
    public func save() throws {
        try ProjectStore.shared.save(self)
    }

    /// Persistable conformance: forwarded to DataServ implementation
    public static func loadAll() throws -> [Project] {
        return try ProjectStore.shared.loadAll()
    }
}
