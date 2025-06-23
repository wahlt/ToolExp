//
//  CPUProfiler.swift
//  ServiceKit
//
//  Specification:
//  • Measures CPU usage and wall-clock times for performance analysis.
//  • Exposes metrics for profiling ToolTune SuperStage.
//
//  Discussion:
//  ToolTune needs fine-grained CPU metrics to identify hotspots.
//  This util wraps Mach APIs for user and system time.
//
//  Rationale:
//  • Easily integrate into diagnostics dashboards.
//  • No external dependencies beyond Darwin.
//
//  Dependencies: Darwin
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct CPUProfile {
    public let userTime:   TimeInterval
    public let systemTime: TimeInterval
}

public enum CPUProfiler {
    /// Returns CPU usage since process start.
    public static func profile() -> CPUProfile {
        var info = rusage()
        getrusage(RUSAGE_SELF, &info)
        let ut = TimeInterval(info.ru_utime.tv_sec)  + TimeInterval(info.ru_utime.tv_usec)  / 1_000_000
        let st = TimeInterval(info.ru_stime.tv_sec)  + TimeInterval(info.ru_stime.tv_usec)  / 1_000_000
        return CPUProfile(userTime: ut, systemTime: st)
    }
}

