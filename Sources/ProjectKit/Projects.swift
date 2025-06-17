//
//  Projects.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Projects.swift
// ProjectKit — Manages multiple project workspaces and their metadata.
//
// Responsibilities:
//  • Track open projects, each with its own folder, settings, and Rep collection.
//  • Create, rename, delete, and switch projects.
//  • Persist project list via SwiftData or AppSettings.
//

import Foundation
import SwiftData

/// A single project workspace.
@Model
public class ProjectEntity {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var folderURL: URL

    public init(id: UUID = .init(), name: String, folderURL: URL) {
        self.id = id
        self.name = name
        self.folderURL = folderURL
    }
}

/// High-level API for managing multiple projects.
public actor Projects {
    private let context: ModelContext

    /// Inject a ModelContext configured with `ProjectEntity`.
    public init(context: ModelContext = {
        ModelContext([ProjectEntity.self])
    }()) {
        self.context = context
    }

    /// List all saved projects.
    public func list() async throws -> [ProjectEntity] {
        try context.fetch(FetchDescriptor<ProjectEntity>())
    }

    /// Create a new project with the given name at folder URL.
    public func create(name: String, at folderURL: URL) async throws -> ProjectEntity {
        let p = ProjectEntity(name: name, folderURL: folderURL)
        context.insert(p)
        try context.save()
        return p
    }

    /// Delete an existing project.
    public func delete(_ project: ProjectEntity) async throws {
        context.delete(project)
        try context.save()
    }

    /// Rename a project.
    public func rename(_ project: ProjectEntity, to newName: String) async throws {
        project.name = newName
        try context.save()
    }
}
