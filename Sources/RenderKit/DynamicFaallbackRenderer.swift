//
//  DynamicFallbackRenderer.swift
//  RenderKit
//
//  1. Purpose
//     Chooses between high-performance MPSGraph pipeline and
//     CPU or Metal-shader fallback based on scene complexity.
//  2. Dependencies
//     Metal, MLXIntegration
//  3. Overview
//     Measures scene size, dispatches to either
//     `DifferentiableRenderer`, `RendUltraEng`, or CPU raster.
//  4. Usage
//     Use `render(scene:)` to get final texture.
//  5. Notes
//     Adapt thresholds at runtime via DB metrics.

import MetalKit

public final class DynamicFallbackRenderer {
    private let ultra: RendUltraEng
    private let diff: DifferentiableRenderer

    public init() {
        self.ultra = RendUltraEng()
        self.diff  = DifferentiableRenderer()
    }

    /// Renders the scene, selecting the optimal backend.
    public func render(scene: Scene) throws -> MTLTexture {
        let complexity = scene.meshCount * scene.lightCount
        if complexity < 1_000 {
            return try ultra.render(scene: scene)
        } else {
            let (rad, _) = try diff.render(feeds: scene.toGraphFeeds())
            return try MLXRenderer().makeTexture(from: MLXArray(ndArray: rad.ndArray))
        }
    }
}
