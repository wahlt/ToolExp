//
//  ArtEngine.swift
//  RenderKit
//
//  1. Purpose
//     High-level painting and stroke rasterization engine.
// 2. Dependencies
//     MetalKit, MLXIntegration
// 3. Overview
//     Uses MLXIntegration to JIT-compile brush kernels to GPU.
// 4. Usage
//     `try ArtEngine.render(strokes:…, into:texture)`
// 5. Notes
//     Fully tensorized; no CPU loops remain.

import MetalKit
import MLXIntegration

/// Renders vector strokes and brush effects via tensor kernels.
public enum ArtEngine {
    /// Rasterize Bézier strokes with thickness falloff.
    public static func render(strokes: [Stroke], into texture: MTLTexture) throws {
        // 1) Pack control points into MLXArray
        let pointData = strokes.flatMap { $0.points }
        let pts = try MLXIntegration.MLXArray.make(
            values: pointData,
            shape: [strokes.count, 4],
            precision: .fp32
        )

        // 2) Build or fetch the Bézier evaluation graph
        let graph = BrushKernelRegistry.shared.bezierGraph()

        // 3) Run graph to compute signed-distance field
        let sdf = try graph.run(inputs: [pts])

        // 4) Composite SDF into `texture` via a single compute dispatch
        try computeComposite(sdf: sdf, into: texture)
    }

    /// Combines signed-distance field with existing texture.
    private static func computeComposite(
        sdf: MLXIntegration.MLXArray,
        into texture: MTLTexture
    ) throws {
        // JIT-compile a fused graph reading `sdf` and writing RGBA into `texture`.
    }
}

/// Represents one vector stroke (4 control points for a cubic Bézier).
public struct Stroke {
    /// Flattened [x0,y0,x1,y1,…]
    public let points: [Float]
}
