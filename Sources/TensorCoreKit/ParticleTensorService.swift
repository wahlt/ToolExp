//
//  ParticleTensorService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  ParticleTensorService.swift
//  TensorCoreKit
//
//  1. Purpose
//     Simulates particle systems (positions & velocities)
//     via MPSGraph in parallel.
// 2. Dependencies
//     MetalPerformanceShadersGraph, MLX
// 3. Overview
//     Integrates movement under forces f = m·a with explicit Euler.
// 4. Usage
//     let result = try ParticleTensorService.shared.simulate(
//         positions: posArr, velocities: velArr, forces: frArr, dt:0.016
//     )
// 5. Notes
//     positions, velocities, forces are shape [N×D].

import MetalPerformanceShadersGraph
import MLX

public final class ParticleTensorService {
    public static let shared = ParticleTensorService()
    private init() {}

    /// One Euler integration step: x' = x + v·dt, v' = v + (f/m)·dt
    public func simulate(
        positions pos: MLXArray,
        velocities vel: MLXArray,
        forces f: MLXArray,
        mass: Float = 1.0,
        dt: Float
    ) throws -> (newPos: MLXArray, newVel: MLXArray) {
        let g = MPSGraph()
        let shape = pos.shape.map { NSNumber(value: $0.intValue) }
        let posPH = g.placeholder(shape: shape, dataType: .float32, name: "pos")
        let velPH = g.placeholder(shape: shape, dataType: .float32, name: "vel")
        let fPH   = g.placeholder(shape: shape, dataType: .float32, name: "f")

        // a = f/m
        let a    = g.multiply(fPH, g.constant(1.0/mass, shape:[], dataType:.float32))
        let vNew = g.add(velPH, g.multiply(a, g.constant(dt, shape:[], dataType:.float32)))
        let xNew = g.add(posPH, g.multiply(vNew, g.constant(dt, shape:[], dataType:.float32)))

        let feeds: [MPSGraphTensor: MPSGraphTensorData] = [
            posPH: try pos.toMPSGraphTensorData(),
            velPH: try vel.toMPSGraphTensorData(),
            fPH:   try f.toMPSGraphTensorData()
        ]
        let res = try g.run(
            feeds: feeds,
            targetTensors: [xNew, vNew],
            targetOperations: nil
        )
        return (
            newPos: try MLXArray(ndArray: res[xNew]!.ndArray),
            newVel: try MLXArray(ndArray: res[vNew]!.ndArray)
        )
    }
}
