//
//  GeometryTensorService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  GeometryTensorService.swift
//  RenderKit
//
//  1. Purpose
//     Packs scene meshes into MLXArray tensors for batched transformations,
//     skinning, and culling in MPSGraph.
//  2. Dependencies
//     MLXIntegration, MetalPerformanceShadersGraph
//  3. Overview
//     Builds shape-[N,3] position arrays, [N,3] normal arrays,
//     and cached transform graphs.
//  4. Usage
//     Use `pack(meshes:)` and then run `transformGraph(...)`.
//  5. Notes
//     Supports per-frame LRU caching of graphs.

import MLXIntegration
import MetalPerformanceShadersGraph

public final class GeometryTensorService {
    /// Packs an array of `Mesh` into MLXArray buffers.
    public func pack(meshes: [Mesh]) throws -> (positions: MLXArray, normals: MLXArray) {
        let posData = meshes.flatMap { $0.vertices.flatMap { [$0.x, $0.y, $0.z] } }
        let norData = meshes.flatMap { $0.normals.flatMap  { [$0.x, $0.y, $0.z] } }
        let count   = meshes.reduce(0) { $0 + $1.vertices.count }
        let positions = try MLXArray.make(values: posData, shape: [count,3], precision: .fp32)
        let normals   = try MLXArray.make(values: norData, shape: [count,3], precision: .fp32)
        return (positions, normals)
    }

    /// Applies world‐to‐clip transforms to all vertices in one graph run.
    public func transformGraph(
        positions: MLXArray,
        matrix: simd_float4x4
    ) throws -> MLXArray {
        let flat = matrix.columns.flatMap { [$0.x,$0.y,$0.z,$0.w] }
        let mat   = try MLXArray.make(values: flat, shape: [4,4], precision: .fp32)
        let (g, inPos, inMat, outPos) = TensorGraphRegistry.shared.matrixMulGraph(
            rows: positions.shape[0].intValue,
            cols: 4
        )
        let feeds: [MPSGraphTensor: MPSGraphTensorData] = [
            inPos: try positions.toMPSGraphTensorData(),
            inMat: try mat.toMPSGraphTensorData()
        ]
        let res = try g.run(feeds: feeds, targetTensors: [outPos], targetOperations: nil)
        return try MLXArray(ndArray: res[outPos]!.ndArray)
    }
}
