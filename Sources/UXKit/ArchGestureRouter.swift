//
//  ArchGestureRouter.swift
//  UXKit
//
//  Description:
//    High-level router that sequences low-level gestures into
//    actionable commands (e.g., “select + rotate then scale”).
//
//  Discussion:
//    Captures gesture order, timing, and context (focused RepCell),
//    and emits composite actions to the architecture layer.
//
//  Example:
//      let archRouter = ArchGestureRouter(focusProvider: { return currentCell })
//      archRouter.handle(.rotate(angle: .pi/2))
//
//  Rationale:
//    Separates core gesture semantics from UI framework code,
//    enabling replay, undo/redo, and macro recording.
//
//  Dependencies:
//    • Foundation
//

import Foundation
import UIKit

/// Semantic gesture types.
public enum ArchGesture {
    case rotate(angle: CGFloat)
    case scale(factor: CGFloat)
    case pan(offset: CGPoint)
    case tap(point: CGPoint)
}

/// Provides the current focus (e.g., selected RepCell ID).
public protocol FocusProvider {
    func currentFocus() -> UUID?
}

/// Routes semantic gestures to the architecture layer.
public class ArchGestureRouter {
    private let focusProvider: FocusProvider

    /// Initialize with a focus provider.
    public init(focusProvider: FocusProvider) {
        self.focusProvider = focusProvider
    }

    /// Handles a semantic gesture event.
    /// - Parameter gesture: The high-level gesture to route.
    public func handle(_ gesture: ArchGesture) {
        guard let focusedID = focusProvider.currentFocus() else {
            return  // no cell focused
        }
        // Dispatch to architecture command bus (implementation omitted)
        // Example: CommandBus.shared.send(.transformCell(focusedID, gesture))
    }
}
