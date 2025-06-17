//
//  Port.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Port.swift
// DataServ — Cell‐port connector APIs.
//
// Offers immutable-fluent `connecting` and `disconnecting` methods.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Connect `sourceID.port` → `targetID`, returning a new Rep.
    ///
    /// - Throws:
    ///   - `RepError.cellNotFound(sourceID)` if the source is missing.
    ///   - `RepError.cellNotFound(targetID)` if the target is missing.
    func connecting(cell sourceID: RepID, port: String, to targetID: RepID) throws -> RepStruct {
        guard cells[sourceID] != nil else { throw RepError.cellNotFound(sourceID) }
        guard cells[targetID] != nil else { throw RepError.cellNotFound(targetID) }

        var copy = self
        var cell = copy.cells[sourceID]!
        cell.ports[port] = targetID
        copy.cells[sourceID] = cell
        return copy
    }

    /// Disconnect the named port, returning a new Rep.
    ///
    /// - Throws: `RepError.cellNotFound(sourceID)` if the source is missing.
    func disconnecting(cell sourceID: RepID, port: String) throws -> RepStruct {
        guard cells[sourceID] != nil else { throw RepError.cellNotFound(sourceID) }

        var copy = self
        var cell = copy.cells[sourceID]!
        cell.ports.removeValue(forKey: port)
        copy.cells[sourceID] = cell
        return copy
    }
}
