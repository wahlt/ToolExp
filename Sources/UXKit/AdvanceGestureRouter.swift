//
//  AdvanceGestureRouter.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  AdvancedGestureRouter.swift
//  UXKit
//
//  Description:
//    Routes complex multi-touch gestures (pinch, rotate, swipe)
//    into high-level semantic actions for Tool’s gesture system.
//
//  Discussion:
//    Detects UIGestureRecognizer events, recognizes compound gestures,
//    and forwards semantic commands (zoom, rotate, pan) to a delegate.
//
//  Example:
//      let router = AdvancedGestureRouter(delegate: myHandler)
//      view.addGestureRecognizer(router.pinchRecognizer)
//      view.addGestureRecognizer(router.rotateRecognizer)
//
//  Rationale:
//    Encapsulating gesture logic keeps view controllers slim
//    and enables reuse across multiple UI contexts.
//
//  Dependencies:
//    • UIKit
//

import UIKit

/// Delegate protocol receiving semantic gesture commands.
public protocol AdvancedGestureHandler: AnyObject {
    func didZoom(scale: CGFloat)
    func didRotate(angle: CGFloat)
    func didPan(translation: CGPoint)
}

/// Recognizes pinch, rotate, and pan gestures and routes them.
public class AdvancedGestureRouter {
    public weak var delegate: AdvancedGestureHandler?

    /// Pinch recognizer for zoom gestures.
    public let pinchRecognizer: UIPinchGestureRecognizer

    /// Rotation recognizer for rotate gestures.
    public let rotateRecognizer: UIRotationGestureRecognizer

    /// Pan recognizer for panning.
    public let panRecognizer: UIPanGestureRecognizer

    /// Initializes router with a handler.
    public init(delegate: AdvancedGestureHandler) {
        self.delegate = delegate
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    }

    @objc private func handlePinch(_ rec: UIPinchGestureRecognizer) {
        if rec.state == .changed {
            delegate?.didZoom(scale: rec.scale)
            rec.scale = 1.0  // reset incremental scale
        }
    }

    @objc private func handleRotate(_ rec: UIRotationGestureRecognizer) {
        if rec.state == .changed {
            delegate?.didRotate(angle: rec.rotation)
            rec.rotation = 0  // reset incremental rotation
        }
    }

    @objc private func handlePan(_ rec: UIPanGestureRecognizer) {
        if rec.state == .changed {
            let translation = rec.translation(in: rec.view)
            delegate?.didPan(translation: translation)
            rec.setTranslation(.zero, in: rec.view)
        }
    }
}
