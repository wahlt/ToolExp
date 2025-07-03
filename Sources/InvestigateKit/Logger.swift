//
//  Logger.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  Logger.swift
//  InvestigateKit
//
//  Lightweight façade over os.log for tagged logging.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import os

public enum LogLevel {
    case debug, info, error
}

public struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "ToolExp"
    private static let general = OSLog(subsystem: subsystem, category: "General")

    public static func log(_ message: String, level: LogLevel = .info) {
        let osType: OSLogType = {
            switch level {
            case .debug: return .debug
            case .info:  return .info
            case .error: return .error
            }
        }()
        os_log("%{public}@", log: general, type: osType, message)
    }
}
