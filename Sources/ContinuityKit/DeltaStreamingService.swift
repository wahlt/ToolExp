//
//  DeltaStreamingService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/DeltaStreamingService.swift
//
//  DeltaStreamingService.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Streams JSON‐encoded CRDT deltas over a ContinuityTransport.

import Foundation

public final class DeltaStreamingService {
    public static let shared = DeltaStreamingService()
    private init() {}

    private var transport: ContinuityTransport?

    public func setTransport(_ t: ContinuityTransport) {
        transport = t
    }

    /// Sends a CRDT delta as JSON over the transport.
    public func sendDelta(_ json: String) {
        guard let data = json.data(using: .utf8) else { return }
        transport?.send(data)
    }

    /// Starts listening for incoming deltas and applies via merge service.
    public func startListening() {
        transport?.receive { data in
            if let json = String(data: data, encoding: .utf8) {
                var rep = /* current RepStruct in context */
                    RepStruct(id: "", nodes: [], ports: [])
                CRDTRepMergeService.shared.merge(deltaJSON: json, into: &rep)
            }
        }
    }
}
