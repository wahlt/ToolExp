//
//  SelectFilter.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// SelectFilter.swift
// DataServ — Cell selection and filtering APIs.
//
// Simple value‐based filters over the `cells` dictionary.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Return all cells whose labels satisfy the given predicate.
    ///
    /// - Parameter predicate: a `(Cell) -> Bool` closure.
    /// - Returns: an array of cells matching the predicate.
    func selectCells(where predicate: (Cell) -> Bool) -> [Cell] {
        return cells.values.filter(predicate)
    }
}
