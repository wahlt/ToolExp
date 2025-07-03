//
//  MLXArray+Precision.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  MLXArray+Precision.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Adds precision-aware constructors to MLXArray.
//  2. Dependencies
//     MLX, MetalPerformanceShadersGraph
//  3. Overview
//     Builds MPSNDArray with selected precision then wraps in MLXArray.
//  4. Usage
//     Call `MLXArray.make(values:shape:precision:)`.
//  5. Notes
//     Precision enum maps to MPSDataType.

import MLX
import MetalPerformanceShadersGraph

/// Precision modes for tensor computations.
public enum Precision: String, CaseIterable, Identifiable {
    case fp16, fp32, fp64
    public var id: Precision { self }
    public var dataType: MPSDataType {
        switch self {
        case .fp16: return .float16
        case .fp32: return .float32
        case .fp64: return .float64
        }
    }
    public var description: String {
        switch self {
        case .fp16: return "Half (fp16)"
        case .fp32: return "Float (fp32)"
        case .fp64: return "Double (fp64)"
        }
    }
}

public extension MLXArray {
    /// Creates an MLXArray from Float values with given shape and precision.
    static func make(
        values: [Float],
        shape: [Int],
        precision: Precision
    ) throws -> MLXArray {
        let nsShape = shape.map { NSNumber(value: $0) }
        let nd = MPSNDArray(
            device: MPSGraphDevice.default(),
            shape: nsShape,
            dataType: precision.dataType,
            values: values
        )
        return try MLXArray(ndArray: nd)
    }
}
