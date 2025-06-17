//
//  RenderAdaptor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RenderAdapter.swift
// RenderKit — Bridges MetalKit’s MTKView with our Renderer API.
//
// Responsibilities:
//  • Set up `MTKViewDelegate` to call `Renderer.render(_:in:)`.
//  • Manage drawable resizing and depth/stencil textures.
//  • Provide a single `Renderer` protocol for callers.
//

import Foundation
import MetalKit
import RepKit

/// Unified renderable interface.
public protocol Renderer {
    /// Draw the given Rep into the MTKView’s current drawable.
    func render(_ rep: RepStruct, in view: MTKView)
}

/// MTKViewDelegate that delegates to our `Renderer`.
public final class RenderAdapter: NSObject, MTKViewDelegate {
    private let renderer: Renderer
    private let view: MTKView

    public init(renderer: Renderer, view: MTKView) {
        self.renderer = renderer
        self.view = view
        super.init()
        view.delegate = self
        view.depthStencilPixelFormat = .depth32Float
    }

    public func draw(in view: MTKView) {
        guard let rep = ToolShared.currentRep else { return }
        renderer.render(rep, in: view)
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // TODO: update camera/projection matrices
    }
}
