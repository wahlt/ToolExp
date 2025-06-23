//
//  DefaultNumericEngine.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// DefaultNumericEngine.swift
// ToolMath — A basic numeric engine stub.
//
// Provides simple implementations of basic numeric operations,
// meant to be swapped with a high‐performance tensor engine later.
//

import Foundation

/// Protocol defining core numeric operations.
public protocol NumericEngine {
    /// Add two Double arrays elementwise.
    func add(_ a: [Double], _ b: [Double]) -> [Double]

    /// Multiply two Double arrays elementwise.
    func multiply(_ a: [Double], _ b: [Double]) -> [Double]

    /// Compute the dot-product of two vectors.
    func dot(_ a: [Double], _ b: [Double]) -> Double
}

/// Default in-memory numeric engine.
public struct DefaultNumericEngine: NumericEngine {
    public init() {}

    public func add(_ a: [Double], _ b: [Double]) -> [Double] {
        precondition(a.count == b.count, "Vector lengths must match")
        return zip(a, b).map(+)
    }

    public func multiply(_ a: [Double], _ b: [Double]) -> [Double] {
        precondition(a.count == b.count, "Vector lengths must match")
        return zip(a, b).map(*)
    }

    public func dot(_ a: [Double], _ b: [Double]) -> Double {
        precondition(a.count == b.count, "Vector lengths must match")
        return zip(a, b).reduce(0) { $0 + $1.0 * $1.1 }
    }
}
