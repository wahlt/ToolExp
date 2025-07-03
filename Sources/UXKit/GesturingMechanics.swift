//
//  GesturingMechanics.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  GesturingMechanics.swift
//  UXKit
//
//  1. Purpose
//     Translates raw `GesturePoint`s into domain actions via PhysicsKit.
// 2. Dependencies
//     Combine, PhysicsKit
// 3. Overview
//     Applies spring/damper to smooth input, recognizes drags/flings.
// 4. Usage
//     Subscribe to `GestureCaptureManager` then feed into this.
// 5. Notes
//     Outputs `GestureAtom` events for `ArchEng`.

import Foundation
import Combine
import PhysicsKit

/// High-level atomic gesture events.
public enum GestureAtom {
    case fling(direction: CGVector, speed: CGFloat)
    case drag(displacement: CGVector)
    case tap(at: CGPoint)
}

/// Consumes raw points, applies smoothing, emits `GestureAtom`s.
public final class GesturingMechanics {
    private var cancellable: AnyCancellable?

    /// Subscribe to raw capture and publish atomic events.
    public func subscribe(to raw: AnyPublisher<GesturePoint, Never>) -> AnyPublisher<GestureAtom, Never> {
        raw
            .map { point -> GestureAtom in
                // simple threshold logic: velocity > v0 => fling, else drag
                let v = PhysicsKit.computeVelocity(previous: point.position, current: point.position, dt: 0.016)
                if hypot(v.dx, v.dy) > 500 {
                    return .fling(direction: v, speed: hypot(v.dx,v.dy))
                } else {
                    return .drag(displacement: CGVector(dx: v.dx*0.016, dy: v.dy*0.016))
                }
            }
            .eraseToAnyPublisher()
    }
}
