//
//  GestureAtom.swift
//  RepKit
//
//  Specification:
//  • Atomic record of a gesture event: timing, touch points, degree, order.
//  • Used to build a GestureRep sequence for interpretation.
//
//  Discussion:
//  Gesture blooms rely on knowing each touch-set’s ordering and degree.
//
//  Rationale:
//  • Immutable struct allows threading replay and diagnostics.
//  Dependencies: Foundation, CoreGraphics
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import CoreGraphics

public struct GestureAtom: Codable {
    public let timestamp: TimeInterval
    public let points: [CGPoint]
    public let degree: Int
    public let order: Int

    public init(timestamp: TimeInterval,
                points: [CGPoint],
                degree: Int,
                order: Int)
    {
        self.timestamp = timestamp
        self.points = points
        self.degree = degree
        self.order = order
    }
}
