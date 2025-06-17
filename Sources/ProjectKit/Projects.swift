// Projects.swift
// CRUD for ProjectEntity using SwiftData (iOS/macOS 26+)

import Foundation
import SwiftData

@Model
public class ProjectEntity: Observable {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var lastModified: Date

    public init(
        id: UUID = .init(),
        name: String,
        lastModified: Date = .init()
    ) {
        self.id = id
        self.name = name
        self.lastModified = lastModified
    }
}

/// Manages your Projects database.
public actor Projects {
    public let context: ModelContext

    public init(
        context: ModelContext = {
            let container = try! ModelContainer(for: [ProjectEntity.self])
            return ModelContext(container: container)
        }()
    ) {
        self.context = context
    }

    public func fetchAll() async throws -> [ProjectEntity] {
        try await context.fetch(FetchDescriptor<ProjectEntity>())
    }

    public func save(_ project: ProjectEntity) async throws {
        context.insert(project)
        try context.save()
    }

    public func delete(_ project: ProjectEntity) async throws {
        context.delete(project)
        try context.save()
    }
}
