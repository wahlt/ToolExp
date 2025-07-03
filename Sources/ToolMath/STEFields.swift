//
//  STEFields.swift
//  ToolMath
//
//  1. Purpose
//     Defines scalar, vector, and tensor field types.
// 2. Dependencies
//     MLX
// 3. Overview
//     Wraps `MLXArray` with spatial metadata.
// 4. Usage
//     `Field1D(data:mlxArray, spacing:1.0)`
// 5. Notes
//     Enables easy gradient/divergence calls.

import MLX

public struct Field1D {
    public let data: MLXArray
    public let Δ: Float

    public init(data: MLXArray, spacing Δ: Float) {
        precondition(data.shape.count == 1, "Field1D must be rank-1")
        self.data = data
        self.Δ    = Δ
    }

    public func gradient() throws -> MLXArray {
        return try TensorCalculus.gradient1D(data, Δ: Δ)
    }
}

public struct Field2D {
    public let data: MLXArray
    public let Δ: Float

    public init(data: MLXArray, spacing Δ: Float) {
        precondition(data.shape.count == 2, "Field2D must be rank-2")
        self.data = data
        self.Δ    = Δ
    }

    public func gradient() throws -> MLXArray {
        return try TensorCalculus.gradient2D(data, Δ: Δ)
    }
}

public struct Field3D {
    public let data: MLXArray
    public let Δ: Float

    public init(data: MLXArray, spacing Δ: Float) {
        precondition(data.shape.count == 3, "Field3D must be rank-3")
        self.data = data
        self.Δ    = Δ
    }

    public func gradient() throws -> MLXArray {
        return try TensorCalculus.gradient3D(data, Δ: Δ)
    }
}
