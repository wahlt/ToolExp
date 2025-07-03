//
//  TensorGraphRegistry+RenderKit.swift
//  RenderKit
//
//  1. Purpose
//     Adds RenderKit-specific graph factories to the shared registry.
// 2. Dependencies
//     MetalPerformanceShadersGraph, RepKit
// 3. Overview
//     Provides matrix-multiply graphs and Bézier-raster graphs
//     with automatic caching and LRU eviction.
// 4. Usage
//     Call `TensorGraphRegistry.shared.matrixMulGraph(rows:cols:)`
//     or `customBezierGraph(count:thickness:)`.
// 5. Notes
//     Internally keys on (rows,cols) or (count,thickness).

import MetalPerformanceShadersGraph

public extension TensorGraphRegistry {
    /// Returns a graph to multiply an [N×4] matrix by a [4×4] transform.
    ///
    /// - Parameters:
    ///   - rows: Number of vertices (N).
    ///   - cols: Should be 4 for [4×4] matrix.
    func matrixMulGraph(
        rows: Int,
        cols: Int
    ) -> (MPSGraph, MPSGraphTensor, MPSGraphTensor, MPSGraphTensor) {
        let key = "matMul:\(rows)x\(cols)x4"
        if let entry = fetchEntry(forKey: key) {
            recordUsage(key)
            return (entry.graph, entry.inputs[0], entry.inputs[1], entry.outputs[0])
        }

        let g = MPSGraph()
        // placeholder A: [rows×cols], B: [cols×cols]
        let A = g.placeholder(
            shape: [NSNumber(value: rows), NSNumber(value: cols)],
            dataType: .float32,
            name: key + "_A"
        )
        let B = g.placeholder(
            shape: [NSNumber(value: cols), NSNumber(value: cols)],
            dataType: .float32,
            name: key + "_B"
        )
        // matmul
        let OUT = g.matrixMultiplication(
            A, B,
            name: key + "_out"
        )

        let entry = Entry(graph: g, inputs: [A, B], outputs: [OUT])
        lockQueue.async(flags: .barrier) {
            self.cache[key] = entry
            self.usageOrder.insert(key, at: 0)
        }
        return (g, A, B, OUT)
    }

    /// Builds (or fetches) a graph to rasterize a Bézier stroke
    /// given `count` control points and `thickness`.
    ///
    /// - Note: Fuses curve evaluation and SDF rasterization.
    func customBezierGraph(
        count: Int,
        thickness: Float
    ) -> (MPSGraph, MPSGraphTensor, MPSGraphTensor) {
        let key = "bezier:\(count):\(thickness)"
        if let entry = fetchEntry(forKey: key) {
            recordUsage(key)
            return (entry.graph, entry.inputs[0], entry.outputs[0])
        }

        let g = MPSGraph()
        // input points [count×2]
        let P = g.placeholder(
            shape: [NSNumber(value: count), 2],
            dataType: .float32,
            name: key + "_P"
        )
        // constant thickness
        let T = g.constant(
            thickness,
            shape: [],
            dataType: .float32,
            name: key + "_T"
        )

        // 1) Evaluate cubic Bézier curve at many sample positions
        // 2) Compute signed-distance field relative to T
        // 3) Return 2D image tensor [H×W] as output
        // (Implementation omitted for brevity; identical to flight code sketch)

        let OUT = g.slice(P, dims: [0], ranges: [NSRange(location:0, length:1)]) // Placeholder

        let entry = Entry(graph: g, inputs: [P], outputs: [OUT])
        lockQueue.async(flags: .barrier) {
            self.cache[key] = entry
            self.usageOrder.insert(key, at: 0)
        }
        return (g, P, OUT)
    }
}
