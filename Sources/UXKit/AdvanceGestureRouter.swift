// File: Sources/UXKit/AdvanceGestureRouter.swift
//  UXKit
//
//  Specification:
//  • Protocol defining how high‐level semantic gestures are routed to application logic.
//
//  Discussion:
//  AdvanceGestureRouter implementation receives decoded gestures
//  from the global capture system and dispatches them to business‐specific handlers.
//
//  Rationale:
//  • Decouples gesture recognition from application code.
//  • Enables multiple routing strategies via dependency injection.
//
//  TODO:
//  • Provide default router implementations for common gestures.
//  • Integrate with HUDOverlayManager to visualize routing decisions.
//
//  Dependencies: Foundation, UIKit (optional)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//
import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Router that receives high‐level gestures and maps them to app actions.
public protocol AdvanceGestureRouting: AnyObject {
    /// Called when a decoded gesture event arrives.
    /// - Parameter gesture: The originating UIGestureRecognizer instance.
    func handleGesture(_ gesture: UIGestureRecognizer)
}
