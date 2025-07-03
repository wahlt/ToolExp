//
//  DefaultNumericEngine.swift
//  ToolMath
//
//  1. Purpose
//     CPU fallback implementation of basic numeric routines.
// 2. Dependencies
//     Foundation
// 3. Overview
//     Provides element-wise add, sub, mul, div on Swift arrays.
// 4. Usage
//     Use when GPU (MLX/MPSGraph) is unavailable or for small sizes.
// 5. Notes
//     Matches TensorEngine API for seamless switching.

import Foundation

public struct DefaultNumericEngine {
    public init() {}

    /// Element-wise addition of two arrays.
    public func add(_ a: [Float], _ b: [Float]) -> [Float] {
        precondition(a.count == b.count, "Mismatched lengths for add")
        return zip(a,b).map(+)
    }

    public func subtract(_ a: [Float], _ b: [Float]) -> [Float] {
        precondition(a.count == b.count, "Mismatched lengths for sub")
        return zip(a,b).map(-)
    }

    public func multiply(_ a: [Float], _ b: [Float]) -> [Float] {
        precondition(a.count == b.count, "Mismatched lengths for mul")
        return zip(a,b).map(*)
    }

    public func divide(_ a: [Float], _ b: [Float]) -> [Float] {
        precondition(a.count == b.count, "Mismatched lengths for div")
        return zip(a,b).map(/)
    }

    public func dot(_ a: [Float], _ b: [Float]) -> Float {
        precondition(a.count == b.count, "Mismatched lengths for dot")
        return zip(a,b).reduce(0) { $0 + $1.0 * $1.1 }
    }
}
