//
//  MLXRenderer.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  MLXRenderer.swift
//  RenderKit
//
//  1. Purpose
//     Renders MLXArray image tensors into MTLTextures.
// 2. Dependencies
//     Metal, MLXIntegration
// 3. Overview
//     Wraps MLXIntegration.MLXRenderer for easy import.
// 4. Usage
//     Call `MLXRenderer(device:).makeTexture(from:)`.
// 5. Notes
//     Alias to the integration implementation.

import Metal
import MLXIntegration

/// Exposes the MLXIntegration renderer in RenderKit.
public typealias MLXRenderer = MLXIntegration.MLXRenderer
