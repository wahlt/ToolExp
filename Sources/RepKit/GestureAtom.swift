//
//  GestureAtom.swift
//  RepKit
//
//  Created by ToolExp on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//
//  1. Purpose
//     Captures low-level gesture events as data atoms.
//  2. Dependencies
//     Foundation, CoreGraphics
//  3. Overview
//     Encodes type, location, timestamp, extra info.
//  4. Usage
//     UXKit dispatches GestureAtom instances to StageKit.
//  5. Notes
//     Additional info can include pressure, rotation, scale.

import Foundation
import CoreGraphics

/// A single gesture event with all relevant parameters.
public struct GestureAtom: Codable {
    public enum GestureType: String, Codable {
        case tap, drag, pinch, rotate, longPress
    }

    public let type: GestureType
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let info: [String: AnyCodable]

    /// Initializes a GestureAtom.
    public init(
        type: GestureType,
        location: CGPoint,
        timestamp: TimeInterval = CACurrentMediaTime(),
        info: [String: AnyCodable] = [:]
    ) {
        self.type = type
        self.location = location
        self.timestamp = timestamp
        self.info = info
    }
}
