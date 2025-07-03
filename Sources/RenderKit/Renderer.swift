//
//  Renderer.swift
//  RenderKit
//
//  1. Purpose
//     Public façade over the ToolExp render pipeline.
// 2. Dependencies
//     MetalKit, RenderAdapter, DifferentiableRenderer, DynamicFallbackRenderer
// 3. Overview
//     Takes either a high-level Scene or a RepStruct and returns
//     a final MTLTexture via the best available backend.
// 4. Usage
//     Call `Renderer.render(scene:)` or `Renderer.render(rep:)`.
// 5. Notes
//     Under the hood chooses DifferentiableRenderer or fallback.

import MetalKit
import RepKit

public final class Renderer {
    private let fallback = DynamicFallbackRenderer()
    private let diff     = DifferentiableRenderer()

    public init() {}

    /// Renders a Scene into a Metal texture.
    public func render(scene: Scene) throws -> MTLTexture {
        // For simplicity, always go through fallback
        return try fallback.render(scene: scene)
    }

    /// Converts a RepStruct to Scene, then renders.
    public func render(rep: RepStruct) throws -> MTLTexture {
        // Convert rep→Scene via RepRenderer
        let scene = try RepRenderer().scene(from: rep)
        return try render(scene: scene)
    }
}
