//
//  Edit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Edit.swift
// DataServ — In-place Rep editing (rename, data updates).
//
// Offers convenience methods on `RepStruct` that return
// new immutable blooms with the requested edit applied.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Return a new Rep with the specified cell renamed.
    ///
    /// - Parameters:
    ///   - id: the `RepID` of the cell to rename.
    ///   - newLabel: the replacement label.
    /// - Throws: `RepError.cellNotFound` if the ID is missing.
    func renaming(cell id: RepID, to newLabel: String) throws -> RepStruct {
        // 1) Ensure the cell exists
        guard let oldCell = cells[id] else {
            throw RepError.cellNotFound(id)
        }

        // 2) Make a copy of the Rep and the target Cell
        var copy = self
        var updatedCell = oldCell

        // 3) Apply the label change
        updatedCell.label = newLabel

        // 4) Store back into the dictionary
        copy.cells[id] = updatedCell
        return copy
    }

    /// Return a new Rep with the specified cell’s data replaced.
    ///
    /// - Parameters:
    ///   - cellID: the `RepID` of the cell to update.
    ///   - newData: the new `AnyCodable` payload.
    /// - Throws: `RepError.cellNotFound` if the cell is missing.
    func updatingData(of cellID: RepID, to newData: AnyCodable) throws -> RepStruct {
        guard let oldCell = cells[cellID] else {
            throw RepError.cellNotFound(cellID)
        }

        var copy = self
        var updatedCell = oldCell
        updatedCell.data = newData
        copy.cells[cellID] = updatedCell
        return copy
    }
}
