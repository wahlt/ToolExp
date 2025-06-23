// File: Sources/ServiceKit/FPKit.swift
//  ServiceKit
//
//  Specification:
//  • Fault Protection Kit: centralized logging, recovery, and user notification.
//
//  Discussion:
//  FPKit records errors with contextual metadata,
//  supports retry-based recovery strategies,
//  and presents user‐friendly alerts when invoked.
//
//  Rationale:
//  • Consistent, centralized error handling improves robustness.
//  • Sendable error logs can flow through async/actor contexts safely.
//  • UIKit alert code is optional and guarded by `canImport` to allow cross-platform builds.
//
//  TODO:
//  • Persist logs to disk or remote telemetry service.
//  • Add granular recovery actions per error context.
//
//  Dependencies: Foundation, UIKit (optional)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//
import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Single error entry with timestamp and context for later analysis.
public struct ErrorLog: Sendable {
    public let timestamp: Date
    public let error:     Error
    public let context:   String
}

/// Central fault‐protection service for ToolExp.
public class FPKit {
    /// Shared singleton instance.
    public static let shared = FPKit()
    private init() {}

    /// Recorded error logs.
    private(set) public var logs: [ErrorLog] = []

    /// Record an error with context string.
    public func record(_ error: Error, context: String) {
        logs.append(ErrorLog(timestamp: Date(), error: error, context: context))
        // TODO: persist logs to disk or remote store
    }

    /// Attempt context‐based recovery after an error.
    public func attemptRecovery() {
        // TODO: implement specific recovery strategies per context
    }

    /// Present the latest error in a UIAlertController.
    public func showLatestError(in vc: UIViewController) {
        #if canImport(UIKit)
        guard let last = logs.last else { return }
        let alert = UIAlertController(
            title: "An error occurred",
            message: last.error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Dismiss", style: .cancel))
        alert.addAction(.init(title: "Retry",   style: .default) { _ in
            self.attemptRecovery()
        })
        vc.present(alert, animated: true)
        #endif
    }
}
