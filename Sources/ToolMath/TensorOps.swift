//
//  TensorOps.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TensorOps.swift
//  ToolMath
//
//  1. Purpose
//     Low-level element-wise tensor operations via MPSGraph.
// 2. Dependencies
//     MLX, MetalPerformanceShadersGraph
// 3. Overview
//     Exposes add, mul, negate, sqrt on MLXArray via graph caching.
// 4. Usage
//     `TensorOps.add(a,b)`
// 5. Notes
//     Best for large tensors; small ones auto-fallback to MLX JIT.

import MLX
import MetalPerformanceShadersGraph

public enum TensorOps {
    public static func add(
        _ a: MLXArray, _ b: MLXArray
    ) throws -> MLXArray {
        let g = MPSGraph()
        let inA = g.placeholder(shape:a.shape.map{NSNumber(value:$0.intValue)}, dataType:.float32, name:"addA")
        let inB = g.placeholder(shape:b.shape.map{NSNumber(value:$0.intValue)}, dataType:.float32, name:"addB")
        let out = g.add(inA, inB, name:"addOut")
        let r = try g.run(
            feeds: [inA:try a.toMPSGraphTensorData(),
                    inB:try b.toMPSGraphTensorData()],
            targetTensors:[out],targetOperations:nil
        )
        return try MLXArray(ndArray: r[out]!.ndArray)
    }

    public static func multiply(
        _ a: MLXArray, _ b: MLXArray
    ) throws -> MLXArray {
        let g = MPSGraph()
        let A = g.placeholder(shape:a.shape.map{NSNumber(value:$0.intValue)}, dataType:.float32, name:"mulA")
        let B = g.placeholder(shape:b.shape.map{NSNumber(value:$0.intValue)}, dataType:.float32, name:"mulB")
        let O = g.multiply(A, B, name:"mulOut")
        let r = try g.run(
            feeds: [A:try a.toMPSGraphTensorData(), B:try b.toMPSGraphTensorData()],
            targetTensors:[O], targetOperations:nil
        )
        return try MLXArray(ndArray: r[O]!.ndArray)
    }

    public static func negate(_ a: MLXArray) throws -> MLXArray {
        let g = MPSGraph()
        let A = g.placeholder(shape:a.shape.map{NSNumber(value:$0.intValue)}, dataType:.float32, name:"negA")
        let O = g.negate(A, name:"negOut")
        let r = try g.run(feeds:[A:try a.toMPSGraphTensorData()], targetTensors:[O], targetOperations:nil)
        return try MLXArray(ndArray: r[O]!.ndArray)
    }

    public static func sqrt(_ a: MLXArray) throws -> MLXArray {
        let g = MPSGraph()
        let A = g.placeholder(shape:a.shape.map{NSNumber(value:$0.intValue)}, dataType:.float32, name:"sqrtA")
        let O = g.squareRoot(A, name:"sqrtOut")
        let r = try g.run(feeds:[A:try a.toMPSGraphTensorData()], targetTensors:[O], targetOperations:nil)
        return try MLXArray(ndArray: r[O]!.ndArray)
    }
}
