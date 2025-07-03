//
//  Productivity.swift
//  ProjectKit
//
//  1. Purpose
//     Tracks user productivity metrics within the project.
// 2. Dependencies
//     Foundation
// 3. Overview
//     Singleton service exposing productivity info.
// 4. Usage
//     `ProductivityService.shared.log(task:...)`
// 5. Notes
//     Marked `@MainActor` for global concurrency safety.

import Foundation

@MainActor
public final class ProductivityService {
    /// Singleton instance; safe under the MainActor.
    public static let shared = ProductivityService()
    private init() {}

    /// Record completion of a work item.
    public func log(task: String, duration: TimeInterval) {
        // append to in-memory buffer or persist...
    }

    // Other productivity methods…
}
