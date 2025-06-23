// File: Sources/ToolMath/TensorKit.swift
//  ToolMath
//
//  Specification:
//  • Provides CPU-based fallback tensor operations.
//  • Exposes `TensorKit.matMul` for matrix multiplication.
//
//  Discussion:
//  The public API is a simple `matMul` that delegates to a private
//  `ComputeFallback` implementation. In future, GPU or BLAS-optimized
//  backends can be slotted in here without changing callers.
//
//  Rationale:
//  • Isolates CPU fallback from public API.
//  • Ensures functionality even if MLXIntegration is unavailable.
//
//  TODO:
//  • Benchmark and optimize fallback.
//  • Add GPU-accelerated paths under ToolTensor SuperStage.
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct TensorKit {
    /// Multiply two matrices A (m×n) and B (n×p) → (m×p).
    public static func matMul(_ A: [[Float]], _ B: [[Float]]) -> [[Float]] {
        ComputeFallback.matMul(A, B)
    }
}

/// Private CPU-based implementation of matrix multiplication.
/// Using nested loops, O(m·n·p) time, suffices as a fallback.
private enum ComputeFallback {
    /// Performs basic matrix multiplication.
    /// - Parameters:
    ///   - A: m×n matrix
    ///   - B: n×p matrix
    /// - Returns: m×p result matrix
    static func matMul(_ A: [[Float]], _ B: [[Float]]) -> [[Float]] {
        let m = A.count
        let n = A.first?.count ?? 0
        let p = B.first?.count ?? 0

        // Initialize result with zeros
        var result = Array(
            repeating: Array(repeating: Float(0), count: p),
            count: m
        )

        // Standard triple-loop multiplication
        for i in 0..<m {
            for k in 0..<n {
                let aik = A[i][k]
                for j in 0..<p {
                    result[i][j] += aik * B[k][j]
                }
            }
        }
        return result
    }
}
