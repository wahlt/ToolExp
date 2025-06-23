//
//  TensorKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  TensorKit.swift
//  ToolMath
//
//  Specification:
//  • Basic tensor operations on nested arrays.
//  • Supports reshape, transpose, contraction (Einstein summation).
//
//  Discussion:
//  Light-weight pure-Swift fallback for MLX tiling logic.
//
//  Rationale:
//  • Prototype tensor flows without metal compile.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public enum TensorKit {
    /// Reshapes a flat array into a 2D matrix.
    public static func reshape(
        flat data: [Float],
        rows: Int,
        cols: Int
    ) -> [[Float]] {
        precondition(rows*cols == data.count, "Shape mismatch")
        return stride(from: 0, to: data.count, by: cols).map { idx in
            Array(data[idx..<idx+cols])
        }
    }
    
    /// Transposes a 2D matrix.
    public static func transpose(_ A: [[Float]]) -> [[Float]] {
        let rows = A.count, cols = A.first?.count ?? 0
        var B = Array(repeating: Array(repeating: Float(0), count: rows), count: cols)
        for i in 0..<rows {
            for j in 0..<cols {
                B[j][i] = A[i][j]
            }
        }
        return B
    }
    
    /// Contracts two 2D tensors on shared axis.
    public static func contract(
        _ A: [[Float]],
        _ B: [[Float]]
    ) -> [[Float]] {
        return ComputeFallback.matMul(A, B)
    }
}
