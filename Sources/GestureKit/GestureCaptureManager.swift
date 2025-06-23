// File: Sources/GestureKit/GestureCaptureManager.swift
//  GestureKit
//
//  Specification:
//  • Captures UIKit-based gestures on a UIView and republishes them via Combine.
//  • Ensures thread-safety by isolating the singleton to the MainActor.
//
//  Discussion:
//  UIKit is only available on iOS/tvOS, so we wrap imports in `#if canImport(UIKit)`.
//  Clients subscribe to `gesturePublisher` to receive raw `UIGestureRecognizer` events,
//  then map them to higher-level GestureTraits elsewhere in the pipeline.
//
//  Rationale:
//  • `@MainActor` on the class and its `shared` instance silences concurrency-safety warnings.
//  • Combine publisher decouples gesture capture from gesture handling logic.
//  • Conditional imports maintain cross-platform build compatibility.
//
//  TODO:
//  • Add support for pan, pinch, long-press, and hover gestures.
//  • On visionOS, replace with PointerInteractivity APIs under a `#if canImport(PointerInteractivity)` guard.
//  • Expose gesture metadata (location, velocity) in a custom `GestureEvent` type.
//
//  Dependencies: Foundation, Combine, CoreGraphics, UIKit (iOS only)
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Combine
import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

@MainActor
public final class GestureCaptureManager {
    /// Shared singleton for global gesture capture; runs on MainActor.
    public static let shared = GestureCaptureManager()

    private init() {}

    #if canImport(UIKit)
    private var gestureRecognizers: [UIGestureRecognizer] = []
    private let subject = PassthroughSubject<UIGestureRecognizer, Never>()

    /// Publisher emitting raw `UIGestureRecognizer` events.
    public var gesturePublisher: AnyPublisher<UIGestureRecognizer, Never> {
        subject.eraseToAnyPublisher()
    }

    /// Attach default recognizers (tap, etc.) to a UIView.
    /// - Parameter view: The target UIView to instrument.
    public func attach(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handle(_:)))
        view.addGestureRecognizer(tap)
        gestureRecognizers.append(tap)
        // TODO: attach pan, pinch, longPress, etc.
    }

    @objc private func handle(_ recognizer: UIGestureRecognizer) {
        subject.send(recognizer)
    }
    #endif
}
