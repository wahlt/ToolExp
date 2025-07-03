//
//  LintKitService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BuildKit/LintKitService.swift
//
//  LintKitService.swift
//  BuildKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Runs SwiftLint on the given source directory.

import Foundation

public final class LintKitService {
    public static let shared = LintKitService()
    private init() {}

    /// Invoke `swiftlint lint` in the specified folder.
    /// - Parameter path: Folder containing Swift source files.
    /// - Throws: If swiftlint returns a non-zero exit code.
    public func lint(at path: String) throws {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["swiftlint", "--path", path]
        task.launch()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw NSError(
                domain: "LintKitService",
                code: Int(task.terminationStatus),
                userInfo: ["message": "swiftlint failed"]
            )
        }
    }
}
