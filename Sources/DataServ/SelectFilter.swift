//
//  SelectFilter.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-25.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Enables selection and filtering on model sets.
//

import Foundation
import SwiftData

public struct SelectFilter {
    /// Performs an async filter of @Model entities.
    public static func apply<T: @Model>(_ predicate: NSPredicate, in context: ModelContext) async throws -> [T] {
        let q = context.query(T.self)
        q.filter(predicate)
        return try await q.fetch()
    }
}
