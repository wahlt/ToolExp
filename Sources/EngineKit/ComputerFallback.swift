//
//  ComputeFallback.swift
//  EngineKit
//
//  Specification:
//  • Provides CPU-based implementations for MLX pipelines as fallback.
//  • Detects absence of Metal Performance Shaders or NPU support.
//
//  Discussion:
//  When MLX shader compilation fails or device lacks hardware support,
//  we need pure-Swift CPU routines to ensure correctness over performance.
//
//  Rationale:
//  • Graceful degradation preserves user workflows.
//  • Centralizing fallbacks avoids scattered “if #available” checks.
//
//  Dependencies: Metal
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Metal

public enum ComputeFallback {
    /// Fallback vector dot-product implementation in Swift.
    public static func dot(_ a: [Float], _ b: [Float]) -> Float {
        precondition(a.count == b.count, "Vector lengths must match")
        var sum: Float = 0
        for i in 0..<a.count { sum += a[i] * b[i] }
        return sum
    }

    /// Fallback matrix multiplication (A rows × B columns).
    public static func matMul(_ A: [[Float]], _ B: [[Float]]) -> [[Float]] {
        let m = A.count, n = B.count, p = B.first?.count ?? 0
        precondition(A.first?.count == n, "Incompatible matrices")
        var C = Array(repeating: Array(repeating: Float(0), count: p), count: m)
        for i in 0..<m {
            for j in 0..<p {
                var acc: Float = 0
                for k in 0..<n {
                    acc += A[i][k] * B[k][j]
                }
                C[i][j] = acc
            }
        }
        return C
    }

    /// Checks at runtime whether to use fallback.
    public static var shouldFallback: Bool {
        guard let dev = MTLCreateSystemDefaultDevice() else { return true }
        return !dev.supportsFeatureSet(.iOS_GPUFamily5_v1)
    }
}
