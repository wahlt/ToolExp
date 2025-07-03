//
//  ConvolutionService.swift
//  TensorCoreKit
//
// 1. Purpose
//    Provides convolution ops as tensor graphs.
// 2. Dependencies
//    MetalPerformanceShadersGraph, MLXIntegration
// 3. Overview
//    Generates and caches convolution graphs.

import Foundation
import MetalPerformanceShadersGraph
import MLXIntegration

public enum ConvolutionService {
    /// Build or fetch a cached 2D convolution graph.
    public static func convolution2DGraph(
        kernelSize: (Int, Int),
        precision: Precision = .fp32
    ) -> (MPSGraph, MPSGraphTensor, MPSGraphTensor, MPSGraphTensor) {
        // … full implementation …
        fatalError("Implement graph factory")
    }

    /// Run the 2D convolution.
    public static func convolve2D(
        _ input: MLXIntegration.MLXArray,
        kernel: MLXIntegration.MLXArray
    ) throws -> MLXIntegration.MLXArray {
        let (graph, inT, kerT, outT) = convolution2DGraph(
            kernelSize: (kernel.shape[0].intValue, kernel.shape[1].intValue),
            precision: .fp32
        )
        let result = graph.run(
            feeds: [inT: try input.toMPSNDArray(),
                    kerT: try kernel.toMPSNDArray()],
            targetTensors: [outT],
            targetOperations: nil
        )
        return try MLXIntegration.MLXArray(ndArray: result[outT]!)
    }
}
