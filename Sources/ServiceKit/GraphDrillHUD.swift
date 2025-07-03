//
//  GraphDrillHUD.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  GraphDrillHUD.swift
//  ServiceKit
//
//  1. Purpose
//     On-screen overlay showing recent MPSGraph execution metrics.
// 2. Dependencies
//     UIKit, MLXIntegration
// 3. Overview
//     Captures graph run times from MLXGraph delegate,
//     displays FPS and ms per graph in a floating view.
// 4. Usage
//     GraphDrillHUD.shared.show(in: someView)
// 5. Notes
//     Automatically hides after a timeout or tap.

import UIKit
import MLXIntegration

public final class GraphDrillHUD {
    public static let shared = GraphDrillHUD()
    private init() {}

    private var label: UILabel?
    private var container: UIView?
    private var timer: Timer?

    /// Shows the HUD in a parent view.
    public func show(in parent: UIView) {
        hide()
        let c = UIView(frame: CGRect(x: 20, y: 50, width: 120, height: 50))
        c.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        c.layer.cornerRadius = 8
        let l = UILabel(frame: c.bounds.insetBy(dx: 8, dy: 8))
        l.numberOfLines = 2
        l.textColor = .white
        l.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        c.addSubview(l)
        parent.addSubview(c)
        self.container = c
        self.label     = l
        // subscribe to MLXGraph notifications
        NotificationCenter.default.addObserver(
            self, selector: #selector(update(_:)),
            name: .mlxGraphDidRun, object: nil
        )
        // auto-hide after 5s
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.hide()
        }
    }

    /// Hides and cleans up.
    public func hide() {
        timer?.invalidate()
        timer = nil
        container?.removeFromSuperview()
        container = nil
        label = nil
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func update(_ note: Notification) {
        // Expect userInfo: ["duration": Double, "tensorCount": Int]
        guard let info = note.userInfo,
              let duration = info["duration"] as? Double,
              let count    = info["tensorCount"] as? Int else { return }
        label?.text = String(
            format: "Tensors: %d\n%.1f ms",
            count, duration * 1000
        )
    }
}

public extension Notification.Name {
    static let mlxGraphDidRun = Notification.Name("MLXGraphDidRun")
}
