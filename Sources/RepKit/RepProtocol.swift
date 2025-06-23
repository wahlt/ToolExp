//
//  RepProtocol.swift
//  RepKit
//
//  Specification:
//  • Defines operations for loading and mutating Rep graphs.
//  • Abstracts storage backends.
//
//  Discussion:
//  Allows swapping in-memory vs. persistent Rep stores.
//
//  Rationale:
//  • Decouple API from implementation for testability.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public protocol RepProtocol {
    func loadGraph(for repID: UUID) async throws -> ([Cell], [(Int, Int)])
    func updateCells(repID: UUID, cells: [Cell]) async throws
    func applyUpdates(repID: UUID, updates: [RepUpdate]) async throws
}
