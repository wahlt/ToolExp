//
//  TensorAlgebra.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TensorAlgebra.swift
//  ToolMath
//
//  1. Purpose
//     High-performance tensor algebra (outer, trace) via MPSGraph caching.
// 2. Dependencies
//     MLX, MetalPerformanceShadersGraph
// 3. Overview
//     Wraps MLXArray’s JIT for outer, caches graph for trace.
// 4. Usage
//     `TensorAlgebra.outer(a,b)` or `TensorAlgebra.trace(m)`
// 5. Notes
//     Falls back to CPU for small sizes automatically.

import MLX
import MetalPerformanceShadersGraph

public enum TensorAlgebra {
    /// Outer (Kronecker) product via MLXArray JIT.
    public static func outer(_ a: MLXArray, _ b: MLXArray) -> MLXArray {
        return a.outer(b)
    }

    /// Trace of a square matrix via cached MPSGraph kernel.
    public static func trace(_ m: MLXArray) -> Float {
        precondition(m.shape.count == 2 && m.shape[0] == m.shape[1],
                     "TensorAlgebra.trace: input must be square")
        let n = m.shape[0].intValue
        let (g, A, SUM) = TensorGraphRegistry.shared.traceGraph(dim: n)
        let ndIn = try! m.toMPSGraphTensorData()
        let res  = try! g.run(feeds: [A: ndIn],
                              targetTensors: [SUM],
                              targetOperations: nil)
        return res[SUM]!.ndArray.toFloatArray()[0]
    }
}
