//
//  TensorStream.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TensorStream.swift
//  ToolMath
//
//  1. Purpose
//     Streaming interface for large tensor data in chunks.
// 2. Dependencies
//     MLX, MetalPerformanceShadersGraph
// 3. Overview
//     Allows processing of huge tensors by tiling into sub-graphs.
// 4. Usage
//     `TensorStream.processInBatches(tensor, batchSize:…) { ... }`
// 5. Notes
//     Useful for datasets that exceed GPU memory.

import MLX
import MetalPerformanceShadersGraph

public struct TensorStream {
    /// Processes `tensor` in 1D batches of size `batchSize`.
    public static func processInBatches(
        _ tensor: MLXArray,
        batchSize: Int,
        processor: (MLXArray) throws -> MLXArray
    ) throws -> MLXArray {
        let length = tensor.shape[0].intValue
        var resultScalars = [Float]()
        for start in stride(from: 0, to: length, by: batchSize) {
            let len = min(batchSize, length - start)
            let slice = tensor.slice(
                dims: [0],
                ranges: [NSRange(location: start, length: len)]
            )
            let out = try processor(slice)
            resultScalars += out.scalars
        }
        return try MLXArray.make(values: resultScalars, shape: [length], precision: .fp32)
    }
}
