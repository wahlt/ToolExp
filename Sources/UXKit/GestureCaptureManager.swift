//
//  GestureCaptureManager.swift
//  UXKit
//
//  1. Purpose
//     Low-level capture of raw touch, pencil, and mouse events.
// 2. Dependencies
//     UIKit
// 3. Overview
//     Installs event taps to record `GesturePoint`s.
// 4. Usage
//     Attach to `UIWindow` or `UIView` to start capturing.
// 5. Notes
//     Publishes via Combine for real-time subsystems.

import UIKit
import Combine

/// Raw data point from a pointer event.
public struct GesturePoint {
    public let position: CGPoint
    public let pressure: CGFloat
    public let timestamp: TimeInterval
}

/// Captures all pointer events on a view.
public final class GestureCaptureManager: NSObject {
    private weak var view: UIView?
    private let subject = PassthroughSubject<GesturePoint, Never>()

    public var publisher: AnyPublisher<GesturePoint, Never> {
        subject.eraseToAnyPublisher()
    }

    public init(view: UIView) {
        super.init()
        self.view = view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handle(_:)))
        pan.minimumNumberOfTouches = 0
        pan.maximumNumberOfTouches = Int.max
        view.addGestureRecognizer(pan)
    }

    @objc private func handle(_ gr: UIPanGestureRecognizer) {
        let loc = gr.location(in: view)
        let pressure: CGFloat
        if #available(iOS 13.4, *) {
            pressure = gr.force / gr.maximumPossibleForce
        } else {
            pressure = 1.0
        }
        let pt = GesturePoint(position: loc,
                              pressure: pressure,
                              timestamp: gr.state == .began ? gr.minimumNumberOfTouches : gr.translation(in: view).x)
        subject.send(pt)
    }
}
