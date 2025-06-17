//
//  MatKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// MatKit.swift
// ToolMath — Math primitives & helper functions.
//
// Vector and matrix operations, coordinate transforms, etc.
//

import Foundation

/// 3×3 matrix for 2D transformations.
public struct Matrix3x3: Codable, Equatable {
    public var m: [Double]  // row-major, length == 9

    /// Identity matrix.
    public static let identity = Matrix3x3(m: [
        1,0,0,
        0,1,0,
        0,0,1
    ])

    public init(m: [Double]) {
        precondition(m.count == 9, "Matrix3x3 requires 9 elements")
        self.m = m
    }

    /// Multiply two 3×3 matrices.
    public func multiplied(by other: Matrix3x3) -> Matrix3x3 {
        var result = [Double](repeating: 0, count: 9)
        for row in 0..<3 {
            for col in 0..<3 {
                var sum = 0.0
                for k in 0..<3 {
                    sum += m[row*3 + k] * other.m[k*3 + col]
                }
                result[row*3 + col] = sum
            }
        }
        return Matrix3x3(m: result)
    }
}

/// Common math utilities.
public enum MathUtils {
    /// Linearly interpolate between a and b by t∈[0,1].
    public static func lerp(a: Double, b: Double, t: Double) -> Double {
        return a + (b - a) * t
    }
}
