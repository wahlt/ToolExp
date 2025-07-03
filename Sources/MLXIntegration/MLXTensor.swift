//
//  MLXTensor.swift
//  MLXIntegration
//
//  Converts between MLXArray and MPSGraph/MultiArray representations.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import MetalPerformanceShadersGraph
import CoreML
import MLX

public extension MLXArray {
    /// Initialize an MLXArray from an MLMultiArray.
    convenience init(multiArray: MLMultiArray) throws {
        let data = try multiArray.toFloatArray()
        let shape = multiArray.shape.map { Int(truncating: $0) }
        self = try MLXArray.make(values: data, shape: shape, precision: .fp32)
    }

    /// Convert MLXArray to MLMultiArray for CoreML interoperability.
    func toMultiArray() throws -> MLMultiArray {
        let flat = self.scalars
        let mlShape = self.shape.map(NSNumber.init(value:))
        let mlArray = try MLMultiArray(shape: mlShape, dataType: .float32)
        for (i, v) in flat.enumerated() {
            mlArray[i] = NSNumber(value: v)
        }
        return mlArray
    }

    /// Convert MLXArray to MPSGraphTensorData for graph feeds.
    func toMPSGraphTensorData() throws -> MPSGraphTensorData {
        let nd = try self.toMPSNDArray()
        return MPSGraphTensorData(ndArray: nd)
    }
}
