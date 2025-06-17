//
//  NavigateSearch.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// NavigateSearch.swift
// DataServ — Searching and navigation tools for Reps.
//
// Provides utilities to locate cells by label or pattern.
//

import Foundation
import RepKit

public extension RepStruct {
    /// Find the first cell with exactly the given label.
    ///
    /// - Parameter label: the exact label string to match.
    /// - Returns: the `Cell` if found, else `nil`.
    func findCell(named label: String) -> Cell? {
        return cells.values.first { $0.label == label }
    }

    /// Find all cells whose label matches the given regular expression.
    ///
    /// - Parameter regex: a `String` regex pattern.
    /// - Throws: `NSRegularExpression` errors if the pattern is invalid.
    /// - Returns: an array of matching `Cell`s.
    func searchCells(matching regex: String) throws -> [Cell] {
        let rx = try NSRegularExpression(pattern: regex)
        return cells.values.filter {
            rx.firstMatch(
                in: $0.label,
                range: NSRange($0.label.startIndex..< $0.label.endIndex, in: $0.label)
            ) != nil
        }
    }
}
