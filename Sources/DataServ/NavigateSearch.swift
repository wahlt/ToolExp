//
//  NavigateSearch.swift
//  DataServ
//
//  Created by Flight Code on 2025-06-25.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Provides navigation and search within persisted models.
//

import Foundation
import SwiftData

public struct NavigateSearch {
    /// Finds @Model instances whose metadata or fields match `query`.
    public static func find<T: @Model>(_ query: String, in context: ModelContext) async throws -> [T] {
        let predicate = NSPredicate(format: "ANY metadata CONTAINS[cd] %@", query)
        let q = context.query(T.self)
        q.filter(predicate)
        return try await q.fetch()
    }
}
