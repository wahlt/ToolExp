//
//  TelemetryKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  TelemetryKit.swift
//  InvestigateKit
//
//  Sends custom telemetry events (name + properties) to a remote endpoint.
//
//  Created by ChatGPT on 2025-07-02.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct TelemetryKit {
    /// Sends a telemetry event asynchronously.
    /// - Parameters:
    ///   - name: Event name.
    ///   - properties: Key/value details.
    public static func sendEvent(name: String, properties: [String: Any] = [:]) {
        var payload: [String: Any] = [
            "event": name,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
        properties.forEach { payload[$0.key] = $0.value }

        guard let data = try? JSONSerialization.data(withJSONObject: payload) else {
            return
        }
        // Example: post to your analytics server
        var req = URLRequest(url: URL(string: "https://your.server/telemetry")!)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.uploadTask(with: req, from: data)
        task.resume()
    }
}
