// MatKit.swift
// 2D matrix utilities for Tool-exp (conforms to Sendable)

import Foundation

/// 3×3 matrix for 2D transformations.
public struct Matrix3x3: Codable, Equatable, Sendable {
    /// Row-major storage; always length == 9.
    public var m: [Double]

    /// Identity matrix.
    public static let identity = Matrix3x3(m: [
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
    ])

    /// Standard initializer; enforces 9 elements.
    public init(m: [Double]) {
        precondition(m.count == 9, "Matrix3x3 requires exactly 9 elements")
        self.m = m
    }
}
