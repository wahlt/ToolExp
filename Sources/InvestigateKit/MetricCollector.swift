//
//  MetricCollector.swift
//  InvestigateKit
//
// 1. Purpose
//    Subscribe to MetricKit payloads.
// 2. Dependencies
//    Foundation, MetricKit
// 3. Overview
//    Logs or forwards performance metrics.

import Foundation
import MetricKit

@MainActor
public final class MetricCollector: NSObject {
    public static let shared = MetricCollector()

    private override init() {
        super.init()
        MXMetricManager.shared.add(self)
    }
}

// Isolate protocol conformance into a nonisolated extension so it satisfies MXMetricManagerSubscriber.
extension MetricCollector: MXMetricManagerSubscriber {
    nonisolated public func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads {
            Logger.log("Metrics received: \(payload.dictionaryRepresentation)", level: .debug)
        }
    }

    nonisolated public func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for diag in payloads {
            Logger.log("Diagnostics received: \(diag.dictionaryRepresentation)", level: .error)
        }
    }
}
