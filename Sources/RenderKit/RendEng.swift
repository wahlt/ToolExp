//
//  RendEng.swift
//  RenderKit
//
//  1. Purpose
//     High-level render-engine orchestrator for ToolExp.
// 2. Dependencies
//     Renderer
// 3. Overview
//     Provides convenience entrypoint to render with current settings.
// 4. Usage
//     Call `RendEng.shared.run(rep:)` or `run(scene:)`.
// 5. Notes
//     May later incorporate UI-controlled quality presets.

import Foundation
import RepKit

public final class RendEng {
    public static let shared = RendEng()
    private let renderer = Renderer()

    private init() {}

    /// Renders a RepStruct.
    public func run(rep: RepStruct) throws -> MTLTexture {
        return try renderer.render(rep: rep)
    }

    /// Renders a Scene.
    public func run(scene: Scene) throws -> MTLTexture {
        return try renderer.render(scene: scene)
    }
}
