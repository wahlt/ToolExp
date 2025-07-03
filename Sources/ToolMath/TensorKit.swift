//
//  TensorKit.swift
//  ToolMath
//
//  1. Purpose
//     Helpers for converting between MLXArray and MPSGraphTensorData.
// 2. Dependencies
//     MLXIntegration
// 3. Overview
//     Adds convenient extension methods on MLXArray.
// 4. Usage
//     `try array.toMPSGraphTensorData()`
// 5. Notes
//     Wraps MPSNDArray conversions.

import MLX
import MetalPerformanceShadersGraph

public extension MLXArray {
    /// Converts this array into MPSGraphTensorData for feeding graphs.
    func toMPSGraphTensorData() throws -> MPSGraphTensorData {
        let nd = try self.toMPSNDArray()
        return MPSGraphTensorData(ndArray: nd)
    }

    /// Creates a Swift Array of the scalars.
    var scalars: [Float] {
        return try! self.toMPSNDArray().toFloatArray()
    }
}
