//
//  PDEGraphService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  PDEGraphService.swift
//  TensorCoreKit
//
//  1. Purpose
//     Builds MPSGraph pipelines to solve common PDEs
//     (heat, wave) via finite‐difference schemes.
// 2. Dependencies
//     MetalPerformanceShadersGraph, MLX
// 3. Overview
//     Constructs iterative update graphs for each time step.
// 4. Usage
//     let u = try PDEGraphService.solveHeat(
//         initial: u0, alpha:0.1, dt:0.01, steps:100
//     )
// 5. Notes
//     All computation in GPU; no CPU loops at runtime.

import MetalPerformanceShadersGraph
import MLX

public final class PDEGraphService {
    public static let shared = PDEGraphService()
    private init() {}

    /// Solves the 1D heat equation ∂u/∂t = α∂²u/∂x².
    public func solveHeat(
        initial u0: MLXArray,
        alpha: Float,
        dt: Float,
        steps: Int
    ) throws -> MLXArray {
        let N = u0.shape[0].intValue
        let g = MPSGraph()
        // placeholders
        let uPH = g.placeholder(shape:[N], dataType:.float32,name:"u")
        // Laplacian kernel [-1,2,-1]
        let lap = g.constant([-1/dt, 2/dt + 2*alpha/dt, -1/dt],
                             shape:[3],dataType:.float32,name:"lap")
        var u = uPH
        for _ in 0..<steps {
            let du = g.convolution1D(u, weights:lap,strides:[1],paddingLeft:[1],paddingRight:[1])
            u = g.add(u, g.multiply(du, g.constant(dt, shape:[], dataType:.float32)))
        }
        let data0 = try u0.toMPSGraphTensorData()
        let res = try g.run(feeds: [uPH:data0], targetTensors:[u], targetOperations:nil)
        return try MLXArray(ndArray: res[u]!.ndArray)
    }

    /// Solves the 1D wave equation ∂²u/∂t² = c²∂²u/∂x²
    public func solveWave(
        initial u0: MLXArray,
        initialVelocity v0: MLXArray,
        c: Float,
        dt: Float,
        steps: Int
    ) throws -> MLXArray {
        let N = u0.shape[0].intValue
        let g = MPSGraph()
        let uPrevPH = g.placeholder(shape:[N], dataType:.float32,name:"uPrev")
        let vPH     = g.placeholder(shape:[N], dataType:.float32,name:"v0")
        let lapKer  = g.constant([-1,2,-1], shape:[3], dataType:.float32, name:"lap")
        // u1 = u0 + v0*dt + 0.5*(c*dt)²*lap(u0)
        let lap0 = g.convolution1D(uPrevPH, weights:lapKer,strides:[1],paddingLeft:[1],paddingRight:[1])
        let u1   = g.add(
            g.add(uPrevPH, g.multiply(vPH, g.constant(dt, shape:[], dataType:.float32))),
            g.multiply(lap0, g.constant(0.5*c*c*dt*dt,shape:[],dataType:.float32))
        )
        var uPrev = uPrevPH
        var uCurr = u1
        // time steps 2…steps
        for _ in 2...steps {
            let lapCurr = g.convolution1D(uCurr, weights:lapKer,strides:[1],paddingLeft:[1],paddingRight:[1])
            let uNext   = g.add(
                g.multiply(uCurr, g.constant(2,shape:[],dataType:.float32)),
                g.subtract(
                    g.multiply(lapCurr, g.constant(c*c*dt*dt,shape:[],dataType:.float32)),
                    uPrev
                )
            )
            uPrev = uCurr
            uCurr = uNext
        }
        let res = try g.run(
            feeds: [
                uPrevPH: try u0.toMPSGraphTensorData(),
                vPH:     try v0.toMPSGraphTensorData()
            ],
            targetTensors:[uCurr],
            targetOperations:nil
        )
        return try MLXArray(ndArray: res[uCurr]!.ndArray)
    }
}
