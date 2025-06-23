//
//  Renderer.swift
//  RenderKit — Defines common rendering protocols.
//
//  Created by Thomas Wahl on 2025-06-17.
//

import MetalKit
import RepKit

/// Protocol for rendering a scene graph (`RepStruct`) into an `MTKView`.
/// All implementations are isolated to the main actor.
@MainActor
public protocol Renderer {
    /// Render the given `RepStruct` in the specified view.
    ///
    /// - Parameters:
    ///   - rep: The scene graph to render.
    ///   - view: The MetalKit view to draw into.
    func render(_ rep: RepStruct, in view: MTKView)
}

/// Optional protocol for renderers that need to respond to drawable-size changes.
/// Also isolated to the main actor.
@MainActor
public protocol Resizable {
    /// Notifies the renderer that the view’s drawable size has changed.
    ///
    /// - Parameter size: The new drawable size.
    func drawableSizeWillChange(to size: CGSize)
}
