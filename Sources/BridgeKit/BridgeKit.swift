//
//  BridgeKit.swift
//  BridgeKit
//
//  Specification:
//  • Utility layer for interacting with UIKit and other Apple APIs.
//  • Centralizes cross-cutting “bridge” functions (presenting, handoff).
//
//  Discussion:
//  Rather than sprinkling `UIApplication.shared` everywhere, BridgeKit
//  contains common patterns like modal presentation or Continuity handoff.
//
//  Rationale:
//  • Reduces duplicated boilerplate across ViewControllers.
//  • Eases future refactors if Apple’s API changes.
//
//  Dependencies: UIKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import UIKit

public enum BridgeKit {
    /// Presents a view controller modally from the key window’s root.
    ///
    /// If no key window is found, fails silently.
    public static func present(_ vc: UIViewController, animated: Bool = true) {
        let scenes = UIApplication.shared.connectedScenes
        let keyWindow = scenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first { $0.isKeyWindow } }
            .first
        guard let root = keyWindow?.rootViewController else { return }
        if let presented = root.presentedViewController {
            presented.present(vc, animated: animated, completion: nil)
        } else {
            root.present(vc, animated: animated, completion: nil)
        }
    }
}
