// Sources/UXKit/CompoundGestureManager.swift
//
// Aggregates low-level UIKit/AppKit gestures (tap, pan, hover)
// into high-level domain `CompoundGesture` events published via Combine.

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Combine

/// A unified gesture event that can represent tap+drag combinations,
/// pencil hover, etc., in the “Tool” domain.
public struct CompoundGesture {
    // e.g. case tap(location: CGPoint), drag(delta: CGVector), ...
}

/// Manages multiple gesture recognizers and coalesces them
/// into `CompoundGesture` values sent to subscribers.
public final class CompoundGestureManager {
    /// Publisher for downstream subsystems to subscribe and react.
    public let publisher = PassthroughSubject<CompoundGesture, Never>()

    private weak var hostView: AnyObject?

    /// Attach to a host view (UIView on iOS/tvOS, NSView on macOS).
    public init(attachingTo view: AnyObject) {
        self.hostView = view
        configureGestureRecognizers()
    }

    /// Sets up the underlying UIKit/AppKit gesture recognizers.
    private func configureGestureRecognizers() {
        #if os(iOS) || os(tvOS)
        guard let v = hostView as? UIView else { return }
        // e.g. let tapGR = UITapGestureRecognizer(...)
        // v.addGestureRecognizer(tapGR)
        #elseif os(macOS)
        guard let v = hostView as? NSView else { return }
        // e.g. let clickGR = NSClickGestureRecognizer(...)
        // v.addGestureRecognizer(clickGR)
        #endif
        // Hook into each recognizer’s callbacks to emit `CompoundGesture`
    }
}
