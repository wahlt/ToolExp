//
//  CrashReportingKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  CrashReportingKit.swift
//  InvestigateKit
//
//  Installs an uncaught-exception handler to capture
//  crash information for later analysis.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public final class CrashReportingKit {
    public static let shared = CrashReportingKit()
    private init() {}

    /// Installs the global exception handler.
    public func install() {
        NSSetUncaughtExceptionHandler { exception in
            self.handle(exception)
        }
    }

    private func handle(_ exception: NSException) {
        let report = """
        *** Crash Report ***
        Name: \(exception.name.rawValue)
        Reason: \(exception.reason ?? "unknown")
        Stack:
        \(exception.callStackSymbols.joined(separator: "\n"))
        """
        // TODO: write `report` to disk or send to remote server.
        print(report)
    }
}
