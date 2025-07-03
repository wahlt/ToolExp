//
//  FieldAnalysisService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  FieldAnalysisService.swift
//  TensorCoreKit
//
//  1. Purpose
//     Computes derivative-based analyses on tensor fields:
//     gradient magnitude, divergence, curl.
// 2. Dependencies
//     MetalPerformanceShadersGraph, MLX
// 3. Overview
//     Provides helper methods that wrap TensorCalculus functionality.
// 4. Usage
//     let grad = try FieldAnalysisService.gradientMagnitude(field: f)
// 5. Notes
//     All results are MLXArrays for GPU acceleration.

import MetalPerformanceShadersGraph
import MLX
import ToolMath

public final class FieldAnalysisService {
    public static let shared = FieldAnalysisService()
    private init() {}

    /// Computes magnitude of the gradient field.
    public func gradientMagnitude(
        field: MLXArray,
        delta: Float = 1.0
    ) throws -> MLXArray {
        let grad = try TensorCalculus.gradient3D(field, Δ: delta)
        // grad shape [3, ...]; magnitude = sqrt(gx² + gy² + gz²)
        let g0 = grad.slice(dims:[0], ranges:[NSRange(location:0,length:1)])
        let g1 = grad.slice(dims:[0], ranges:[NSRange(location:1,length:1)])
        let g2 = grad.slice(dims:[0], ranges:[NSRange(location:2,length:1)])
        let sq  = g0*s0 + g1*g1 + g2*g2
        let mag = sq.sqrt()
        return mag
    }

    /// Computes divergence of a vector field.
    public func divergence(
        field: MLXArray,
        delta: Float = 1.0
    ) throws -> MLXArray {
        return try TensorCalculus.divergence(field, Δ: delta)
    }

    /// Computes curl of a 3D vector field.
    public func curl(
        field: MLXArray,
        delta: Float = 1.0
    ) throws -> MLXArray {
        return try TensorCalculus.curl(field, Δ: delta)
    }
}
