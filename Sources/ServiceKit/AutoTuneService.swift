//
//  AutoTuneService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  AutoTuneService.swift
//  ServiceKit
//
//  1. Purpose
//     Dynamically adjusts ToolExp performance parameters
//     (e.g., render quality, tensor batch sizes) based on telemetry.
// 2. Dependencies
//     Foundation, ServiceKit/CPUProfiler
// 3. Overview
//     Periodically samples CPU/GPU load and adapts quality settings.
// 4. Usage
//     AutoTuneService.shared.startMonitoring(interval: 5)
// 5. Notes
//     Emits `.autoTuneDidAdjust` notifications on changes.

import Foundation

public final class AutoTuneService {
    public static let shared = AutoTuneService()
    private init() {}

    private var timer: Timer?

    /// Starts periodic monitoring every `interval` seconds.
    public func startMonitoring(interval: TimeInterval) {
        stopMonitoring()
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true
        ) { [weak self] _ in self?.evaluate() }
    }

    /// Stops monitoring.
    public func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    /// Samples load and adjusts settings.
    private func evaluate() {
        let cpu = CPUProfiler.currentCPUUsage()
        // Example logic: if CPU > 80%, lower render LOD
        let newQuality = cpu > 0.8 ? Quality.low : Quality.high
        NotificationCenter.default.post(
            name: .autoTuneDidAdjust,
            object: newQuality
        )
    }

    public enum Quality {
        case low, high
    }
}

public extension Notification.Name {
    static let autoTuneDidAdjust = Notification.Name("AutoTuneServiceDidAdjust")
}
