//
//  GlobalIllumination.swift
//  RenderKit
//
//  1. Purpose
//     Combines direct lighting and probe-based indirect lighting
//     into a final illumination pass.
// 2. Dependencies
//     Metal, MLXIntegration, MetalPerformanceShadersGraph
// 3. Overview
//     Fetches direct lighting via standard shader pass,
//     calls GIProbeRenderer for probes, then blends results
//     via an MPSGraph fusion kernel.
// 4. Usage
//     Call `GlobalIllumination.render(scene:directTexture:)`
//     to get a fully lit texture.
// 5. Notes
//     Falls back to simple add if probe pass unavailable.

import Metal
import MLXIntegration
import MetalPerformanceShadersGraph

public final class GlobalIllumination {
    private let device: MTLDevice
    private let graph: MPSGraph

    public init(device: MTLDevice = MLXCommandQueue.shared.device) {
        self.device = device
        self.graph  = MPSGraph()
        buildGraph()
    }

    private var directTexPH: MPSGraphTensor!
    private var probeTexPH: MPSGraphTensor!
    private var outputTexT: MPSGraphTensor!

    /// Builds a fusion graph: output = direct + weight * probe
    private func buildGraph() {
        // placeholders
        directTexPH = graph.placeholder(
            shape: nil,  // dynamic [H,W,4]
            dataType: .float32,
            name: "GI_direct"
        )
        probeTexPH = graph.placeholder(
            shape: nil,
            dataType: .float32,
            name: "GI_probe"
        )
        // weight constant (e.g. 0.5 indirect)
        let w = graph.constant(0.5, shape: [], dataType: .float32, name: "GI_indirectWeight")
        // multiply probe by weight, then add
        let scaled = graph.multiply(probeTexPH, w, name: "GI_scaledProbe")
        outputTexT  = graph.add(directTexPH, scaled, name: "GI_output")
    }

    /// Runs the GI fusion.
    ///
    /// - Parameters:
    ///   - direct: Shader-rendered direct lighting texture.
    ///   - probes: Probe texture from `GIProbeRenderer`.
    /// - Returns: Final blended texture.
    public func render(
        direct: MTLTexture,
        probes: MTLTexture
    ) throws -> MTLTexture {
        // 1) Convert MTLTextures → MLXArray via MLXRenderer
        let renderer = MLXRenderer(device: device)
        let directArr = try MLXArray(from: direct)
        let probeArr  = try MLXArray(from: probes)

        // 2) Convert to TensorData
        let dData = try directArr.toMPSGraphTensorData()
        let pData = try probeArr.toMPSGraphTensorData()

        // 3) Run fusion graph
        let results = try graph.run(
            feeds: [ directTexPH: dData,
                     probeTexPH: pData ],
            targetTensors: [outputTexT],
            targetOperations: nil
        )
        let outArr = try MLXArray(ndArray: results[outputTexT]!.ndArray)

        // 4) Back to texture
        return try renderer.makeTexture(from: outArr)
    }
}
