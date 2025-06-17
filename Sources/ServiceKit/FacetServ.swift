//
//  FacetServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// FacetServ.swift
// ServiceKit — Manage IconFacet entities & hot-swap backing Reps.
//
// Uses SwiftData to persist Facet → RepID mappings and loads Reps via DataServ.
//

import Foundation
import SwiftData
import RepKit

@Model
public class FacetEntity {
    @Attribute(.unique) public var id: String    // e.g. "icon-user", "icon-settings"
    public var repID: UUID                       // which Rep backs this facet

    public init(id: String, repID: UUID) {
        self.id = id
        self.repID = repID
    }
}

/// Service actor for registering & resolving Facets.
public actor FacetServ {
    private let context: ModelContext
    private let dataServ: DataServ

    public init(context: ModelContext = {
        ModelContext([FacetEntity.self])
    }(), dataServ: DataServ = .init()) {
        self.context = context
        self.dataServ = dataServ
    }

    /// Assign a Rep to a named Facet.
    public func register(facet id: String, repID: UUID) async throws {
        // Delete old mapping if exists
        if let old = try context.fetch(
            FetchDescriptor<FacetEntity>(matching: #Predicate { $0.id == id })
        ).first {
            context.delete(old)
        }
        // Insert new
        let entity = FacetEntity(id: id, repID: repID)
        context.insert(entity)
        try context.save()
    }

    /// Resolve a Facet’s current RepStruct.
    public func resolve(facet id: String) async throws -> RepStruct {
        guard let entity = try context.fetch(
            FetchDescriptor<FacetEntity>(matching: #Predicate { $0.id == id })
        ).first else {
            throw NSError(domain: "FacetServ", code: 404)
        }
        return try await dataServ.load(id: entity.repID)
    }
}
