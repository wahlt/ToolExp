//
//  DynamicFaallbackRenderer.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// DynamicFallbackRenderer.swift
// RenderKit — CPU‐fallback for Metal4 pipelines on unsupported devices.
//
// Responsibilities:
//  • Detect if device lacks Metal4 / MLX support.
//  • Switch to a CPU‐based path tracer or OpenCL fallback.
//  • Mirror the API of `RendUltraEng` so callers need only one interface.
//

import Foundation
import MetalKit
import RepKit

public final class DynamicFallbackRenderer: Renderer {
    private let device: MTLDevice?
    private let queue: MTLCommandQueue?
    private let cpuEnabled: Bool
    private let cpuTracer: CPUPathTracer

    public init(mtkView: MTKView) {
        self.device = mtkView.device
        self.queue  = device?.makeCommandQueue()
        // Detect Metal4 support
        self.cpuEnabled = !(device?.supportsFamily(.apple7) ?? false)
        self.cpuTracer = CPUPathTracer()
    }

    public func render(_ rep: RepStruct, in view: MTKView) {
        if cpuEnabled {
            // CPU fallback
            let image = cpuTracer.trace(rep)
            view.drawable?.texture.replace(
                region: MTLRegionMake2D(0, 0, image.width, image.height),
                mipmapLevel: 0,
                withBytes: image.data,
                bytesPerRow: image.bytesPerRow
            )
        } else {
            // Metal4 path via `RendUltraEng`
            RendUltraEng.shared.render(rep, in: view)
        }
    }
}

/// Simple CPU path tracer stub.
fileprivate class CPUPathTracer {
    func trace(_ rep: RepStruct) -> (width: Int, height: Int, data: UnsafeRawPointer, bytesPerRow: Int) {
        // TODO: implement a minimal ray‐marching CPU fallback
        return (1,1,UnsafeRawPointer(bitPattern: 0)!,0)
    }
}
