//
//  MetricCollector.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

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
public final class MetricCollector: NSObject, MXMetricManagerSubscriber {
    public static let shared = MetricCollector()

    private override init() {
        super.init()
        MXMetricManager.shared.add(self)
    }

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

