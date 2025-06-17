//
//  GlobalIllumination.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// GlobalIllumination.swift
// RenderKit — Precomputes and caches irradiance via Spherical Harmonics.
//
// Responsibilities:
//  • Sample scene via `RepRenderer` probes.
//  • Project lighting onto SH basis.
//  • Provide low‐frequency bounce lighting at runtime.
//

import Foundation
import MetalKit
import simd

public final class GlobalIllumination {
    /// Precompute SH coefficients for the scene at resolution.
    public static func precomputeSH(
        for rep: RepStruct,
        device: MTLDevice,
        resolution: Int
    ) -> [SIMD4<Float>] {
        // 1) Place probes on a grid
        // 2) For each probe: render scene from cube faces via `RepRenderer`
        // 3) Project each face’s pixels onto SH bands (up to L=2 or 3)
        // 4) Return array of 4‐float coefficients [r,g,b,weight]
        return []
    }

    /// Evaluate SH lighting at a surface normal.
    public static func evaluateSH(
        coeffs: [SIMD4<Float>],
        normal: SIMD3<Float>
    ) -> SIMD3<Float> {
        // TODO: compute Y_lm(normal) * coeffs, sum per channel
        return SIMD3<Float>(repeating: 1.0)
    }
}
