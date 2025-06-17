//
//  DataServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// DataServ.swift
// DataServ — Persist and load RepStruct via SwiftData @Model & AnyCodable.
//
// Uses SwiftData’s @Model entities (RepEntity, CellEntity, PortEntity)
// and the community‐style AnyCodable wrapper for value payloads.
// Fully Apple‐native persistence; no JSON involved.
//

import Foundation
import SwiftData
import RepKit

/// Errors thrown by DataServ when loading fails.
public enum DataServError: Error, LocalizedError {
    /// No RepEntity was found matching the given UUID.
    case repNotFound(UUID)

    public var errorDescription: String? {
        switch self {
        case .repNotFound(let id):
            return "No Rep found with ID \(id)."
        }
    }
}

/// High‐level service for saving and loading `RepStruct` instances.
///
/// Wraps a SwiftData `ModelContext` configured with our three @Model types:
/// - `RepEntity`
/// - `CellEntity`
/// - `PortEntity`
///
/// All serialization of cell data uses `AnyCodable` → PropertyListEncoder.
public actor DataServ {
    // MARK: – Internal ModelContext

    /// The SwiftData context used for all operations.
    private let context: ModelContext

    /// Create a DataServ with its own in‐memory or file‐backed ModelContext.
    ///
    /// By default this uses an in‐memory store; you can inject
    /// a different `ModelContext` for testing or file‐based persistence.
    public init(context: ModelContext = {
        ModelContext([RepEntity.self, CellEntity.self, PortEntity.self])
    }()) {
        self.context = context
    }

    // MARK: – Save

    /// Save a `RepStruct` to the data store, replacing any existing one
    /// with the same `rep.id`.
    ///
    /// Steps:
    /// 1. Look up any existing `RepEntity` with matching UUID; delete it if found.
    /// 2. Map each `Cell` in `rep.cells` to a `CellEntity`:
    ///    - Encode `cell.data` (an `AnyCodable`) via `PropertyListEncoder`.
    ///    - Create a `PortEntity` for each `(name, targetID)` in `cell.ports`.
    /// 3. Insert a new `RepEntity(id:name:cells:)` into the context.
    /// 4. Call `context.save()` to persist.
    ///
    /// - Parameter rep: the `RepStruct` to persist.
    public func save(_ rep: RepStruct) async throws {
        // 1. Delete existing entity if present
        let fetch = FetchDescriptor<RepEntity>(
            matching: #Predicate<RepEntity> { $0.id == rep.id }
        )
        let existing = try context.fetch(fetch)
        if let oldEntity = existing.first {
            context.delete(oldEntity)
        }

        // 2. Map cells → CellEntity
        var cellEntities: [CellEntity] = []
        for cell in rep.cells.values {
            // Encode the cell's AnyCodable data to Data
            let blob: Data?
            do {
                let encoder = PropertyListEncoder()
                let wrapped = AnyCodable(cell.data.value)
                blob = try encoder.encode(wrapped)
            } catch {
                blob = nil
            }

            // Create PortEntity objects
            let ports = cell.ports.map { name, targetID in
                PortEntity(name: name, targetID: targetID)
            }

            let cellEnt = CellEntity(
                id:      cell.id,
                label:   cell.label,
                data:    blob,
                ports:   ports
            )
            cellEntities.append(cellEnt)
        }

        // 3. Create and insert the RepEntity
        let repEntity = RepEntity(
            id:    rep.id,
            name:  rep.name,
            cells: cellEntities
        )
        context.insert(repEntity)

        // 4. Persist the context
        try context.save()
    }

    // MARK: – Load

    /// Load a `RepStruct` by its `RepID` from the data store.
    ///
    /// Steps:
    /// 1. Fetch the `RepEntity` matching `id`. Throw `repNotFound` if missing.
    /// 2. Create a base `RepStruct(id:name:)`.
    /// 3. For each `CellEntity` in `RepEntity.cells`:
    ///    - Decode its `data` blob back to `AnyCodable` via `PropertyListDecoder`.
    ///    - Create a `Cell(id:label:data:)` and add it via `rep.adding(cell)`.
    /// 4. For each `CellEntity` and its `PortEntity` children:
    ///    - Call `rep = try rep.connecting(cell:…, port:…, to:…)`.
    /// 5. Return the reconstructed `RepStruct`.
    ///
    /// - Parameter id: the UUID of the `RepStruct` to load.
    /// - Returns: the loaded and fully‐connected `RepStruct`.
    public func load(id: RepID) async throws -> RepStruct {
        let fetch = FetchDescriptor<RepEntity>(
            matching: #Predicate<RepEntity> { $0.id == id }
        )
        let results = try context.fetch(fetch)
        guard let entity = results.first else {
            throw DataServError.repNotFound(id)
        }

        // 2. Initialize the empty RepStruct
        var rep = RepStruct(id: entity.id, name: entity.name)

        // 3. Reconstruct cells (without ports)
        for cellEnt in entity.cells {
            // Decode the AnyCodable blob
            let anyCodable: AnyCodable
            if let blob = cellEnt.data {
                do {
                    let decoder = PropertyListDecoder()
                    anyCodable = try decoder.decode(AnyCodable.self, from: blob)
                } catch {
                    anyCodable = AnyCodable(0) // fallback
                }
            } else {
                anyCodable = AnyCodable(0)
            }

            let cell = Cell(
                id:    cellEnt.id,
                label: cellEnt.label,
                data:  anyCodable
            )
            rep = rep.adding(cell)
        }

        // 4. Recreate ports to fully connect the graph
        for cellEnt in entity.cells {
            for portEnt in cellEnt.ports {
                rep = try rep.connecting(
                    cell: cellEnt.id,
                    port: portEnt.name,
                    to:   portEnt.targetID
                )
            }
        }

        // 5. Return the rebuilt RepStruct
        return rep
    }
}
