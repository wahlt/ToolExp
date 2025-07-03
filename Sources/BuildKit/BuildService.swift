// Sources/BuildKit/BuildService.swift
//
//  BuildService.swift
//  BuildKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Orchestrates Swift package builds via `swift build`.

import Foundation

public final class BuildService {
    public static let shared = BuildService()
    private init() {}

    /// Invoke `swift build --package-path` on the given folder.
    /// - Parameter path: Filesystem path to the Swift package root.
    /// - Throws: An error if the process exits with non-zero status.
    public func build(at path: String) throws {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["swift", "build", "--package-path", path]
        task.launch()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw NSError(
                domain: "BuildService",
                code: Int(task.terminationStatus),
                userInfo: ["message": "swift build failed"]
            )
        }
    }
}
