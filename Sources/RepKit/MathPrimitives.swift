//
//  MathPrimitives.swift
//  RepKit
//
//  Specification:
//  • Typealiases for common mathematical types used in RepKit.
//  • Re-export SIMD types for simplicity.
//
//  Discussion:
//  RepKit and Fysics use 3D vectors and matrices extensively.
//
//  Rationale:
//  • Centralizing these aliases eases future changes.
//  Dependencies: simd
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import simd

public typealias Vector3 = SIMD3<Float>
public typealias Matrix4 = simd_float4x4
