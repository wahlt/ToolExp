//
//  DataServTensorMirror.swift
//  DataServ
//
// 1. Purpose
//    Mirror SwiftData models into tensor arrays.
// 2. Dependencies
//    Foundation, MLXIntegration
// 3. Overview
//    Builds an MLXArray from flat Float values for downstream tensor ops.

import Foundation
import MetalPerformanceShadersGraph
import MLXIntegration

public final class DataServTensorMirror {
    private let graph = MPSGraph()

    /// Build a tensor at `shape` from `values`.
    ///
    /// - Parameters:
    ///   - models: placeholder parameter (not used yet).
    ///   - values: flattened float data to pack.
    ///   - shape: desired tensor shape.
    public func mirror<T>(_ models: [T], values: [Float], shape: [Int]) throws {
        // Create an MLXArray from the raw floats:
        let mlx = try MLXIntegration.MLXArray.make(
            values: values,
            shape: shape,
            precision: .fp32
        )

        // TODO: connect `mlx` back to the `models` array if needed.
        _ = mlx
    }
}
