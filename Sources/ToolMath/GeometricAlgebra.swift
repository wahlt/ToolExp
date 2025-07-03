//
//  GeometricAlgebra.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  GeometricAlgebra.swift
//  ToolMath
//
//  1. Purpose
//     3D Clifford algebra multivector operations via MPSGraph.
// 2. Dependencies
//     MLX, MetalPerformanceShadersGraph
// 3. Overview
//     Implements geometric (Clifford) product, wedge, and meet.
// 4. Usage
//     `try GeometricAlgebra.geometricProduct(a,b)`
// 5. Notes
//     Expects shape-[8] MLXArrays for multivectors.

import MLX
import MetalPerformanceShadersGraph

public enum GeometricAlgebra {
    public enum Error: Swift.Error {
        case invalidInput(String)
    }

    /// Builds or retrieves the cached graph for geoproduct.
    private static func graphForGeo() throws -> (MPSGraph, MPSGraphTensor, MPSGraphTensor, MPSGraphTensor) {
        return try TensorGraphRegistry.shared.geometricProductGraph()
    }

    /// Geometric (Clifford) product of two 3D multivectors.
    public static func geometricProduct(
        _ a: MLXArray, _ b: MLXArray
    ) throws -> MLXArray {
        // Validate shapes
        guard a.shape.count == 1 && a.shape[0].intValue == 8,
              b.shape.count == 1 && b.shape[0].intValue == 8
        else { throw Error.invalidInput("Multivector must be length 8") }

        let (g, A, B, OUT) = try graphForGeo()
        let ndA = try a.toMPSGraphTensorData()
        let ndB = try b.toMPSGraphTensorData()
        let results = try g.run(
            feeds: [A: ndA, B: ndB],
            targetTensors: [OUT],
            targetOperations: nil
        )
        return try MLXArray(ndArray: results[OUT]!.ndArray)
    }

    /// Wedge (outer) product: grade-2 (bivector) part only.
    public static func wedge(
        _ a: MLXArray, _ b: MLXArray
    ) throws -> MLXArray {
        let gp = try geometricProduct(a,b)
        // zero out scalar (0), vector (1–3) and trivector (7)
        var result = gp.scalars
        for idx in [0,1,2,3,7] { result[idx] = 0 }
        return try MLXArray.make(values: result, shape: [8], precision: .fp32)
    }
}
