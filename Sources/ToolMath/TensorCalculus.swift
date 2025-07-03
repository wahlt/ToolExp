//
//  TensorCalculus.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TensorCalculus.swift
//  ToolMath
//
//  1. Purpose
//     GPU-accelerated gradient, divergence, curl on 1D–3D fields.
// 2. Dependencies
//     MLX, MetalPerformanceShadersGraph
// 3. Overview
//     Builds or fetches cached graphs for each operator.
// 4. Usage
//     `try TensorCalculus.gradient2D(field)`
// 5. Notes
//     Falls back to CPU loops if MPSGraph unavailable.

import MLX
import MetalPerformanceShadersGraph

public enum TensorCalculus {
    public static func gradient1D(
        _ field: MLXArray, Δ: Float = 1.0
    ) throws -> MLXArray {
        let n = field.shape[0].intValue
        let (g, IN, OUT) = TensorGraphRegistry.shared.gradient1DGraph(length: n, Δ: Δ)
        let data = try field.toMPSGraphTensorData()
        let res  = try g.run(feeds: [IN: data], targetTensors: [OUT], targetOperations: nil)
        return try MLXArray(ndArray: res[OUT]!.ndArray)
    }

    public static func gradient2D(
        _ field: MLXArray, Δ: Float = 1.0
    ) throws -> MLXArray {
        let graph = MPSGraph()
        let shape = field.shape.map { NSNumber(value: $0.intValue) }
        let IN = graph.placeholder(shape: shape, dataType: .float32, name: "grad2D_in")
        // central diff kernels
        let kx = graph.constant([[-0.5/Δ,0,0.5/Δ]], shape:[1,3], dataType:.float32)
        let ky = graph.constant([[-0.5/Δ],[0],[0.5/Δ]], shape:[3,1], dataType:.float32)
        let gx = graph.convolution2D(IN, weights: kx,
                                     strides:(1,1), dilations:(1,1),
                                     paddingLeft:(0,1), paddingRight:(0,1))
        let gy = graph.convolution2D(IN, weights: ky,
                                     strides:(1,1), dilations:(1,1),
                                     paddingLeft:(1,0), paddingRight:(1,0))
        let OUT = graph.concatTensors([gx,gy], dimension: 0)
        let data = try field.toMPSGraphTensorData()
        let res  = try graph.run(feeds:[IN:data], targetTensors:[OUT], targetOperations:nil)
        return try MLXArray(ndArray: res[OUT]!.ndArray)
    }

    public static func gradient3D(
        _ field: MLXArray, Δ: Float = 1.0
    ) throws -> MLXArray {
        let graph = MPSGraph()
        let shape = field.shape.map { NSNumber(value: $0.intValue) }
        let IN = graph.placeholder(shape: shape, dataType: .float32, name: "grad3D_in")
        let k1 = graph.constant([-0.5/Δ,0,0.5/Δ], shape:[3], dataType:.float32)
        let gx = graph.convolution3D(IN, weights: k1.reshaped(to:[3,1,1]),
                                     paddingLeft:(1,0,0), paddingRight:(1,0,0))
        let gy = graph.convolution3D(IN, weights: k1.reshaped(to:[1,3,1]),
                                     paddingLeft:(0,1,0), paddingRight:(0,1,0))
        let gz = graph.convolution3D(IN, weights: k1.reshaped(to:[1,1,3]),
                                     paddingLeft:(0,0,1), paddingRight:(0,0,1))
        let OUT = graph.concatTensors([gx,gy,gz], dimension: 0)
        let data = try field.toMPSGraphTensorData()
        let res  = try graph.run(feeds:[IN:data], targetTensors:[OUT], targetOperations:nil)
        return try MLXArray(ndArray: res[OUT]!.ndArray)
    }

    public static func divergence(
        _ field: MLXArray, Δ: Float = 1.0
    ) throws -> MLXArray {
        let gx = try divergenceComponent(field, axis: 0, Δ: Δ)
        let gy = try divergenceComponent(field, axis: 1, Δ: Δ)
        let gz = try divergenceComponent(field, axis: 2, Δ: Δ)
        return gx + gy + gz
    }

    private static func divergenceComponent(
        _ field: MLXArray, axis: Int, Δ: Float
    ) throws -> MLXArray {
        // slice out component and apply gradient
        let comp = field.slice(dims:[0], ranges:[NSRange(location:axis,length:1)])
        return try gradient1D(comp, Δ: Δ)
    }

    public static func curl(
        _ field: MLXArray, Δ: Float = 1.0
    ) throws -> MLXArray {
        let f = field
        let dFzdy = try gradient2D(f.slice(dims:[0],ranges:[NSRange(location:2,length:1)]), Δ:Δ)[1]
        let dFydz = try gradient3D(f.slice(dims:[0],ranges:[NSRange(location:1,length:1)]), Δ:Δ)[2]
        let dFxdz = try gradient3D(f.slice(dims:[0],ranges:[NSRange(location:0,length:1)]), Δ:Δ)[2]
        let dFzdx = try gradient1D(f.slice(dims:[0],ranges:[NSRange(location:2,length:1)]), Δ:Δ)
        let dFydx = try gradient1D(f.slice(dims:[0],ranges:[NSRange(location:1,length:1)]), Δ:Δ)
        let dFxdy = try gradient2D(f.slice(dims:[0],ranges:[NSRange(location:0,length:1)]), Δ:Δ)[1]
        let cx = dFzdy - dFydz
        let cy = dFxdz - dFzdx
        let cz = dFydx - dFxdy
        return MLXArray.concat([cx,cy,cz], dimension: 0)
    }
}
