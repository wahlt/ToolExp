//
//  AgentSFX.swift
//  SpatialAudioKit
//
//  1. Purpose
//     Spatial audio processing via tensor graphs.
// 2. Dependencies
//     AVFoundation, MetalPerformanceShadersGraph, MLXIntegration
// 3. Overview
//     Applies realtime spatialization to audio buffers.
// 4. Usage
//     `let out = try AgentSFX.shared.process(buffer:)`.
//

import Foundation
import AVFoundation
import MetalPerformanceShadersGraph
import MLXIntegration

public final class AgentSFX {
    public static let shared = AgentSFX()
    private init() {}

    /// Process an input audio buffer and return spatialized output.
    public func process(buffer: AVAudioPCMBuffer) throws -> AVAudioPCMBuffer {
        let frameCount = Int(buffer.frameLength)
        let ptr = buffer.floatChannelData![0]
        let mlxArray = try MLXIntegration.MLXArray.make(
            values: Array(UnsafeBufferPointer(start: ptr, count: frameCount)),
            shape: [frameCount],
            precision: .fp32
        )

        // Run spatial‐audio tensor graph
        let outArray = try SpatialAudioGraphRegistry.shared.run(inputs: [mlxArray])

        // convert back to AVAudioPCMBuffer…
        return buffer
    }
}
