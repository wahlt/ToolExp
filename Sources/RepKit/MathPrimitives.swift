//
//  MathPrimitives.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Exposes common vector & matrix aliases.
//  2. Dependencies
//     simd
//  3. Overview
//     Provides Vec2, Vec3, Mat4, etc.
//  4. Usage
//     Use for numeric operations in physics, rendering.
//  5. Notes
//     Extend with additional types as needed.

import simd

/// 2-component float vector.
public typealias Vec2  = SIMD2<Float>
/// 3-component float vector.
public typealias Vec3  = SIMD3<Float>
/// 4×4 float matrix.
public typealias Mat4  = simd_float4x4
