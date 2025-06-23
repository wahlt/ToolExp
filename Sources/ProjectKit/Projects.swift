//
//  Projects.swift
//  ProjectKit
//
//  Specification:
//  • Model for Tool projects: metadata, file paths, last modified.
//  • CRUD via DataServ for persistence.
//
//  Discussion:
//  Projects encapsulate workspaces; modeling helps list and switch them.
//
//  Rationale:
//  • Use Persistable to leverage JSON storage.
//  Dependencies: Foundation, DataServ
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import DataServ

public struct Project: Persistable {
    public static let storageKey = "projects"
    public var id: UUID
    public var name: String
    public var path: String
    public var lastModified: Date
}

public enum ProjectManager {
    /// Fetches all saved projects.
    public static func all() throws -> [Project] {
        return try DataServ.shared.loadAll(Project.self)
    }

    /// Saves or updates a project list.
    public static func save(_ list: [Project]) throws {
        try DataServ.shared.saveAll(list, as: Project.self)
    }
}
