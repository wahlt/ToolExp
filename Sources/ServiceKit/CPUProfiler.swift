//
//  CPUProfiler.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// CPUProfiler.swift
// ServiceKit — Lightweight CPU usage profiling via os_signpost.
//
// Wrap hot code sections in `profileSection(_:)` to measure duration in Instruments.
//

import Foundation
import os

public struct CPUProfiler {
    private static let log = OSLog(subsystem: "com.toolkit.service", category: "CPUProfiler")

    /// Profile a synchronous code block.
    public static func profileSection<T>(_ name: StaticString,
                                         block: () throws -> T) rethrows -> T {
        let id = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: id)
        defer { os_signpost(.end, log: log, name: name, signpostID: id) }
        return try block()
    }

    /// Profile an async code block.
    public static func profileAsync<T>(_ name: StaticString,
                                       block: @escaping () async throws -> T) async rethrows -> T {
        let id = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: id)
        defer { os_signpost(.end, log: log, name: name, signpostID: id) }
        return try await block()
    }
}
