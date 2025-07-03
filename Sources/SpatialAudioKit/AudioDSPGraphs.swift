//
//  AudioDSPGraphs.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  AudioDSPGraphs.swift
//  SpatialAudioKit
//
//  1. Purpose
//     Constructs common audio DSP pipelines in MPSGraph.
// 2. Dependencies
//     MetalPerformanceShadersGraph, MLX
// 3. Overview
//     Provides FFT, EQ, convolution reverb, and ML-denoise graphs.
// 4. Usage
//     let (g, inPH, outPH) = AudioDSPGraphs.eqGraph(bands:…)
// 5. Notes
//     All graphs are cached in TensorGraphRegistry for reuse.

import MetalPerformanceShadersGraph
import MLX

public enum AudioDSPGraphs {
    /// Builds (or fetches) an MPSGraph for N-point FFT.
    public static func fftGraph(points: Int) -> (MPSGraph, MPSGraphTensor, MPSGraphTensor) {
        let key = "fft:\(points)"
        if let e = TensorGraphRegistry.shared.fetchEntry(forKey: key) {
            return (e.0, e.1[0], e.2[0])
        }
        let g = MPSGraph()
        let inPH  = g.placeholder(shape: [points], dataType: .float32, name: key + "_in")
        // Real→complex FFT via MPSGraph (placeholder API)
        let outPH = g.fft(inPH, name: key + "_out")
        let entry = TensorGraphRegistry.Entry(graph: g, inputs: [inPH], outputs: [outPH])
        TensorGraphRegistry.shared.insertEntry(entry, forKey: key)
        return (g, inPH, outPH)
    }

    /// Builds a 10-band EQ graph: multiplies FFT bins by gains.
    public static func eqGraph(bands: Int) -> (MPSGraph, MPSGraphTensor, MPSGraphTensor) {
        let key = "eq:\(bands)"
        if let e = TensorGraphRegistry.shared.fetchEntry(forKey: key) {
            return (e.0, e.1[0], e.2[0])
        }
        let g = MPSGraph()
        let inPH  = g.placeholder(shape: [bands], dataType: .float32, name: key + "_in")
        let gains = g.placeholder(shape: [bands], dataType: .float32, name: key + "_gains")
        let outPH = g.multiply(inPH, gains, name: key + "_out")
        let entry = TensorGraphRegistry.Entry(graph: g, inputs: [inPH, gains], outputs: [outPH])
        TensorGraphRegistry.shared.insertEntry(entry, forKey: key)
        return (g, inPH, outPH)
    }

    /// Builds a convolution reverb graph from impulse response.
    public static func reverbGraph(
        ir: MLXArray
    ) throws -> (MPSGraph, MPSGraphTensor, MPSGraphTensor) {
        let key = "reverb:\(ir.shape)"
        if let e = TensorGraphRegistry.shared.fetchEntry(forKey: key) {
            return (e.0, e.1[0], e.2[0])
        }
        let g = MPSGraph()
        let len = ir.shape[0].intValue
        let inPH = g.placeholder(shape: [len], dataType: .float32, name: key + "_in")
        let irPH = g.constant(ir.toFloatArray(), shape: [len], dataType: .float32, name: key + "_ir")
        let outPH = g.convolution1D(
            inPH, weights: irPH,
            strides: [1], paddingLeft: [len-1], paddingRight: [0],
            name: key + "_out"
        )
        let entry = TensorGraphRegistry.Entry(graph: g, inputs: [inPH], outputs: [outPH])
        TensorGraphRegistry.shared.insertEntry(entry, forKey: key)
        return (g, inPH, outPH)
    }

    /// Placeholder for ML-based denoising subgraph (e.g. Core ML).
    public static func denoiseGraph() -> (MPSGraph, MPSGraphTensor, MPSGraphTensor) {
        let key = "denoise"
        if let e = TensorGraphRegistry.shared.fetchEntry(forKey: key) {
            return (e.0, e.1[0], e.2[0])
        }
        let g = MPSGraph()
        let inPH = g.placeholder(shape: nil, dataType: .float32, name: key + "_in")
        // stub: identity pass-through
        let outPH = inPH
        let entry = TensorGraphRegistry.Entry(graph: g, inputs: [inPH], outputs: [outPH])
        TensorGraphRegistry.shared.insertEntry(entry, forKey: key)
        return (g, inPH, outPH)
    }
}
