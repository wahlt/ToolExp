//
//  RepStruct.swift
//  RepKit
//
//  Specification:
//  • In‐memory store of multiple Rep graphs.
//  • Conforms to RepProtocol for graph load/update operations.
//
//  Discussion:
//  Simplest Rep storage: actor‐isolated dictionary of repID→RepStruct.
//
//  Rationale:
//  • Actor ensures thread safety.
//  • In‐memory store can be replaced with DataServ persistence later.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct RepStruct: Codable {
    public let id: UUID
    public var cells: [Cell]
}

public actor RepStructStore: RepProtocol {
    public static let shared = RepStructStore()
    private var store: [UUID: RepStruct] = [:]

    public func loadGraph(for repID: UUID) async throws -> ([Cell], [(Int, Int)]) {
        guard let rep = store[repID] else {
            throw NSError(domain: "RepStruct", code: 404, userInfo: [NSLocalizedDescriptionKey: "Rep not found"])
        }
        let cells = rep.cells
        var edges: [(Int, Int)] = []
        let idIndex = Dictionary(uniqueKeysWithValues: cells.enumerated().map { ($1.id, $0) })
        for (i, cell) in cells.enumerated() {
            for (_, targetID) in cell.ports {
                if let j = idIndex[targetID] {
                    edges.append((i, j))
                }
            }
        }
        return (cells, edges)
    }

    public func updateCells(repID: UUID, cells: [Cell]) async throws {
        guard store[repID] != nil else {
            throw NSError(domain: "RepStruct", code: 404, userInfo: [NSLocalizedDescriptionKey: "Rep not found"])
        }
        store[repID]?.cells = cells
    }

    public func applyUpdates(repID: UUID, updates: [RepUpdate]) async throws {
        guard var rep = store[repID] else {
            throw NSError(domain: "RepStruct", code: 404, userInfo: [NSLocalizedDescriptionKey: "Rep not found"])
        }
        for update in updates {
            rep = update.applying(to: rep)
        }
        store[repID] = rep
    }

    /// Creates a new empty Rep and returns its ID.
    public func createEmpty() -> UUID {
        let rep = RepStruct(id: UUID(), cells: [])
        store[rep.id] = rep
        return rep.id
    }
}
