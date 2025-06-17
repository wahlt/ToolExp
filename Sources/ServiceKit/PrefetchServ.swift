//
//  PrefetchServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// PrefetchServ.swift
// ServiceKit — Preloads assets, Reps, or compute pipelines to minimize UI jank.
//

import Foundation
import Combine
import RepKit

/// Simple cache for prefetching Reps in the background.
public actor PrefetchServ {
    private var cache: [UUID: RepStruct] = [:]

    /// Prefetch a Rep by ID via DataServ.
    public func prefetch(repID: UUID) async {
        if cache[repID] == nil {
            if let rep = try? await DataServ().load(id: repID) {
                cache[repID] = rep
            }
        }
    }

    /// Retrieve a prefetched Rep if available.
    public func cached(repID: UUID) -> RepStruct? {
        return cache[repID]
    }
}
