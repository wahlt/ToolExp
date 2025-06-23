//
//  ArtEngine.swift
//  EngineKit
//
//  Specification:
//  • Hybrid rendering engine combining MetalKit & RealityKit.
//  • Manages render pipelines and draws each frame.
//
//  Discussion:
//  Tool needs both high-fidelity 3D and UI overlays.
//  ArtEngine centralizes setup for both rendering contexts.
//
//  Rationale:
//  • Reusing one engine avoids divergent code paths.
//  • MetalKit for shaders; RealityKit for AR anchoring.
//
//  Dependencies: MetalKit, RealityKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import MetalKit
import RealityKit

public class ArtEngine {
    private let mtkView: MTKView
    private let arView: ARView
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    /// Initializes with MetalKit and RealityKit views.
    public init(mtkView: MTKView, arView: ARView) {
        guard let dev = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal device unavailable")
        }
        self.device = dev
        self.commandQueue = dev.makeCommandQueue()!
        self.mtkView = mtkView
        self.arView = arView
        configure()
    }

    /// Shared pipeline setup for both views.
    private func configure() {
        // Configure MetalKit view.
        mtkView.device = device
        mtkView.preferredFramesPerSecond = 60
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)

        // Configure RealityKit ARView.
        arView.environment.background = .color(.black)
        arView.scene.anchors.removeAll()
    }

    /// Renders a single frame to Metal and AR contexts.
    public func renderFrame() {
        // Step 1: Metal draw call.
        guard let drawable = mtkView.currentDrawable,
              let descriptor = mtkView.currentRenderPassDescriptor else {
            return
        }
        let cmdBuf = commandQueue.makeCommandBuffer()!
        let encoder = cmdBuf.makeRenderCommandEncoder(descriptor: descriptor)!
        // Actual draw calls would bind pipelines, set buffers, etc.
        encoder.endEncoding()
        cmdBuf.present(drawable)
        cmdBuf.commit()

        // Step 2: RealityKit updates internally.
        // (Scene updates handled automatically each frame.)
    }
}
