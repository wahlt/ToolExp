//
//  RendUltraEng.swift
//  RenderKit
//
//  1. Purpose
//     “Ultra” high-quality path tracer using MPSGraph fusion.
// 2. Dependencies
//     DifferentiableRenderer, MLXIntegration
// 3. Overview
//     Always uses the differentiable DRT pipeline (no CPU fallback).
// 4. Usage
//     Call `Ultra.render(scene:)` for production-quality output.
// 5. Notes
//     Slower but supports gradients if needed for ML tasks.

import MLXIntegration

public final class RendUltraEng {
    private let diff = DifferentiableRenderer()

    public init() {}

    /// Renders via fully fused differentiable path-trace.
    public func render(scene: Scene) throws -> MTLTexture {
        let feeds = try scene.toGraphFeeds()
        let (radiance, _) = try diff.render(feeds: feeds)
        // Convert tensor → texture
        return try MLXRenderer().makeTexture(from: MLXArray(ndArray: radiance.ndArray))
    }
}
