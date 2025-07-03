//
//  TemporalDenoiseRenderer.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TemporalDenoiseRenderer.swift
//  RenderKit
//
// 1. Purpose
//     Performs temporal accumulation + denoising in one MPSGraph pass.
// 2. Dependencies
//     MetalPerformanceShadersGraph, MLXIntegration
// 3. Overview
//     Takes current + previous frame tensors,
//     applies temporal blend → edge-aware denoise via convolution.
// 4. Usage
//     Call `render(current:previous:)` each frame.
// 5. Notes
//     Maintains ring buffer of history textures.

import MetalPerformanceShadersGraph
import MLXIntegration

public final class TemporalDenoiseRenderer {
    private let graph: MPSGraph
    private var currPH: MPSGraphTensor!
    private var prevPH: MPSGraphTensor!
    private var blendT: MPSGraphTensor!
    private var denoiseT: MPSGraphTensor!

    public init() {
        graph = MPSGraph()
        buildGraph()
    }

    private func buildGraph() {
        // placeholders
        currPH = graph.placeholder(shape: nil, dataType: .float32, name: "TD_current")
        prevPH = graph.placeholder(shape: nil, dataType: .float32, name: "TD_previous")
        // temporal blend alpha
        let alpha = graph.constant(0.8, shape: [], dataType: .float32, name: "TD_alpha")
        // blend: alpha*curr + (1-alpha)*prev
        let blended = graph.add(
            graph.multiply(currPH, alpha),
            graph.multiply(prevPH, graph.subtract(1, alpha))
        )
        blendT = blended
        // denoise: simple 3×3 Gaussian via separable conv
        let kernel1D: [Float] = [0.25, 0.5, 0.25]
        let kH = graph.constant(kernel1D, shape: [1,3], dataType: .float32, name: "TD_kh")
        let kV = graph.constant(kernel1D, shape: [3,1], dataType: .float32, name: "TD_kv")
        let hPass = graph.convolution2D(
            blended, weights: kH,
            strides: (1,1), dilations: (1,1),
            paddingLeft: (0,1), paddingRight: (0,1)
        )
        let vPass = graph.convolution2D(
            hPass, weights: kV,
            strides: (1,1), dilations: (1,1),
            paddingLeft: (1,0), paddingRight: (1,0)
        )
        denoiseT = vPass
    }

    /// Runs temporal blend + denoise, returns a fresh MLXArray.
    public func render(
        current: MLXArray,
        previous: MLXArray
    ) throws -> MLXArray {
        let currData = try current.toMPSGraphTensorData()
        let prevData = try previous.toMPSGraphTensorData()
        let results = try graph.run(
            feeds: [currPH: currData, prevPH: prevData],
            targetTensors: [denoiseT],
            targetOperations: nil
        )
        let outND = results[denoiseT]!.ndArray
        return try MLXArray(ndArray: outND)
    }
}
