//
//  CPUProfiler.swift
//  ServiceKit
//
//  1. Purpose
//     Measures current CPU utilization of the process.
// 2. Dependencies
//     Foundation, Mach
// 3. Overview
//     Queries Mach host statistics to compute CPU load fraction.
// 4. Usage
//     let usage = CPUProfiler.currentCPUUsage()
// 5. Notes
//     Returns 0–1.0; expensive, use sparingly.

import Foundation
import MachO
import Darwin

public final class CPUProfiler {
    /// Returns CPU usage fraction [0.0 … 1.0].
    public static func currentCPUUsage() -> Double {
        var kr: kern_return_t
        var taskInfoCount: mach_msg_type_number_t = UInt32(MemoryLayout<task_thread_times_info_data_t>.size) / 4
        var tinfo = task_thread_times_info_data_t()

        kr = withUnsafeMutablePointer(to: &tinfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(taskInfoCount)) {
                task_info(mach_task_self_,
                          task_flavor_t(TASK_THREAD_TIMES_INFO),
                          $0,
                          &taskInfoCount)
            }
        }
        guard kr == KERN_SUCCESS else { return 0 }
        // user + system time in microseconds
        let userUS = Double(tinfo.user_time.seconds) + Double(tinfo.user_time.microseconds)/1_000_000
        let sysUS  = Double(tinfo.system_time.seconds) + Double(tinfo.system_time.microseconds)/1_000_000
        // approximate over interval (this is a snapshot)
        return min((userUS + sysUS)/Double(ProcessInfo.processInfo.activeProcessorCount), 1.0)
    }
}
