//
//  MathPrimitives.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// MathPrimitives.swift
// RepKit — Core math types: Vector3 & Matrix4x4.
//
// Value semantics, Codable, Equatable, Sendable for concurrency.
//

import Foundation

/// 3D vector with common operations.
public struct Vector3: Codable, Equatable, Sendable {
    public var x, y, z: Double

    /// Zero vector (0,0,0).
    public static let zero = Vector3(x: 0, y: 0, z: 0)

    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// Add two vectors.
    public static func + (a: Vector3, b: Vector3) -> Vector3 {
        Vector3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)
    }

    /// Subtract two vectors.
    public static func - (a: Vector3, b: Vector3) -> Vector3 {
        Vector3(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)
    }

    /// Scale by a scalar.
    public static func * (v: Vector3, s: Double) -> Vector3 {
        Vector3(x: v.x * s, y: v.y * s, z: v.z * s)
    }

    /// Dot product.
    public func dot(_ other: Vector3) -> Double {
        x * other.x + y * other.y + z * other.z
    }
}

/// 4×4 matrix stub for transforms (column-major).
public struct Matrix4x4: Codable, Equatable, Sendable {
    /// 16-element flat array (column-major).
    public var m: [Double] // length == 16

    /// Identity matrix.
    public static let identity = Matrix4x4(m: [
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    ])

    public init(m: [Double]) {
        precondition(m.count == 16, "Matrix4x4 requires 16 values")
        self.m = m
    }

    /// Multiply two matrices.
    public static func * (A: Matrix4x4, B: Matrix4x4) -> Matrix4x4 {
        var result = [Double](repeating: 0, count: 16)
        // Full standard 4×4 multiply
        for row in 0..<4 {
            for col in 0..<4 {
                var sum = 0.0
                for k in 0..<4 {
                    sum += A.m[k*4 + row] * B.m[col*4 + k]
                }
                result[col*4 + row] = sum
            }
        }
        return Matrix4x4(m: result)
    }
}
