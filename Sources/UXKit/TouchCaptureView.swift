//
//  TouchCaptureView.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  TouchCaptureView.swift
//  UXKit
//
//  Description:
//    SwiftUI wrapper for capturing raw touch events (began,
//    moved, ended) and forwarding them to a TouchHandler.
//
//  Discussion:
//    Uses UIViewRepresentable to host a transparent UIView subclass
//    that overrides touch methods, enabling gesture generation
//    even when SwiftUI’s Gesture modifiers are insufficient.
//
//  Example:
//      TouchCaptureView { event in
//          print("Touch at \(event.location)")
//      }
//
//  Rationale:
//    Provides low-level touch data to gesture routers without
//    interfering with SwiftUI’s view hierarchy.
//
//  Dependencies:
//    • SwiftUI
//    • UIKit
//

import SwiftUI
import UIKit

/// Represents a raw touch event.
public struct TouchEvent {
    public let location: CGPoint
    public let phase: UITouch.Phase
}

/// Handler closure receiving touch events.
public typealias TouchHandler = (TouchEvent) -> Void

/// A SwiftUI view that captures all touch events.
public struct TouchCaptureView: UIViewRepresentable {
    private let handler: TouchHandler

    /// Initialize with a touch handler closure.
    public init(handler: @escaping TouchHandler) {
        self.handler = handler
    }

    public func makeUIView(context: Context) -> UIView {
        let view = TouchUIView(frame: .zero)
        view.touchHandler = handler
        view.backgroundColor = .clear
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // No SwiftUI-driven updates needed
    }

    /// Transparent UIView subclass to intercept touches.
    private class TouchUIView: UIView {
        var touchHandler: TouchHandler?

        public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            dispatch(touches, phase: .began)
        }

        public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            dispatch(touches, phase: .moved)
        }

        public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            dispatch(touches, phase: .ended)
        }

        private func dispatch(_ touches: Set<UITouch>, phase: UITouch.Phase) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            touchHandler?(TouchEvent(location: location, phase: phase))
        }
    }
}
