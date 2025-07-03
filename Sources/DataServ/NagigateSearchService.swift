//
//  NagigateSearchService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  NavigateSearchService.swift
//  DataServ
//
//  Created by Flight Code on 2025-06-25.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Wraps async SwiftData queries in a synchronous interface.
//

import Foundation
import SwiftData

public final class NavigateSearchService {
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
                result = try await context.query(T.self).filter(predicate).fetch()
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
