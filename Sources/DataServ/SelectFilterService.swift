//
//  SelectFilterService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  SelectFilterService.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-27.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Synchronous façade for async SelectFilter.
//

import Foundation
import SwiftData

public final class SelectFilterService {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    /// Fetches models matching `predicate`.
    public func fetch<T: @Model>(predicate: NSPredicate) throws -> [T] {
        let group = DispatchGroup()
        var result: [T] = []
        var error: Error?
        group.enter()
        Task {
            do {
                result = try await SelectFilter.apply(predicate, in: context)
            } catch {
                error = error
            }
            group.leave()
        }
        group.wait()
        if let e = error { throw e }
        return result
    }
}
