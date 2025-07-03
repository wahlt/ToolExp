//
//  RepArray+Tiling.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  RepArray+Tiling.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Provides tiling utilities for flat arrays.
//  2. Dependencies
//     None
//  3. Overview
//     Splits arrays into sub-arrays (tiles) for batch processing.
//  4. Usage
//     Call `tiled(rows:cols:)` on `[Element]` when assembling MPSGraph tensors.
//  5. Notes
//     Useful for image-based or grid-based tensor operations.

import Foundation

public extension Array {
    /// Splits a flat array into a 2D array of given dimensions.
    func tiled(rows: Int, cols: Int) -> [[Element]] {
        precondition(count == rows * cols,
                     "Array size (\(count)) must equal rows*cols (\(rows)*\(cols)).")
        return (0..<rows).map { r in
            Array(self[(r*cols)..<((r+1)*cols)])
        }
    }
}
