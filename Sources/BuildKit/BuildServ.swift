//
//  BuildServ.swift
//  BuildKit
//
//  Specification:
//  • High-level wrapper around the `swift build` process.
//  • Streams stdout/stderr back to caller for display in UI.
//  • Manages process lifecycle and error propagation.
//
//  Discussion:
//  Users should be able to trigger builds inside Tool and see logs.
//  BuildServ encapsulates Process configuration and output capture.
//
//  Rationale:
//  • Abstracting Process setup reduces boilerplate in UI code.
//  • Capturing both stdout & stderr ensures full log visibility.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public protocol BuildServDelegate: AnyObject {
    func buildServ(_ serv: BuildServ, didReceiveLine line: String)
    func buildServ(_ serv: BuildServ, didFinishWith error: Error?)
}

public class BuildServ {
    public weak var delegate: BuildServDelegate?
    private var process: Process?

    /// Starts `swift build` at the specified package path.
    public func build(at path: String) {
        process?.terminate()
        let proc = Process()
        proc.currentDirectoryURL = URL(fileURLWithPath: path)
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        proc.arguments = ["swift", "build"]
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = pipe

        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if let line = String(data: data, encoding: .utf8) {
                self.delegate?.buildServ(self, didReceiveLine: line)
            }
        }

        proc.terminationHandler = { proc in
            pipe.fileHandleForReading.readabilityHandler = nil
            let err = proc.terminationStatus == 0
                ? nil
                : NSError(domain: "BuildServ", code: Int(proc.terminationStatus), userInfo: nil)
            self.delegate?.buildServ(self, didFinishWith: err)
        }

        self.process = proc
        do {
            try proc.run()
        } catch {
            delegate?.buildServ(self, didFinishWith: error)
        }
    }

    /// Cancels an ongoing build.
    public func cancel() {
        process?.terminate()
        process = nil
    }
}
