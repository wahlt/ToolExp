//
//  GestureAtom.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// GestureAtom.swift
// RepKit — Encapsulates a single low‐level gesture event.
//
// Holds all parameters: position, translation, rotation, scale, velocity,
// number of touches, pressure, etc., for fully‐rich HIG gesture debugging.
//

import Foundation
import SwiftUI

/// All gesture types we support (add more as needed).
public enum GestureType: String, Codable, Equatable {
    case tap
    case doubleTap
    case longPress
    case drag
    case pinch
    case rotate
    case swipe
    case custom
}

/// A single gesture sample with maximal detail.
public struct GestureAtom: Codable, Equatable {
    /// Which gesture recognizer fired.
    public let type: GestureType
    /// How many fingers/pointers.
    public let touches: Int
    /// Absolute location of the gesture’s center.
    public let location: CGPoint
    /// Movement delta since gesture began.
    public let translation: CGSize
    /// Rotation (in radians) since gesture began.
    public let rotation: Angle
    /// Scale factor since gesture began.
    public let scale: CGFloat
    /// Velocity vector (points per second).
    public let velocity: CGSize
    /// Force/pressure when available (1.0 = max).
    public let pressure: CGFloat?

    /// Create a rich GestureAtom from various parameters.
    public init(
        type: GestureType,
        touches: Int,
        location: CGPoint,
        translation: CGSize = .zero,
        rotation: Angle = .zero,
        scale: CGFloat = 1.0,
        velocity: CGSize = .zero,
        pressure: CGFloat? = nil
    ) {
        self.type = type
        self.touches = touches
        self.location = location
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
        self.velocity = velocity
        self.pressure = pressure
    }
}
