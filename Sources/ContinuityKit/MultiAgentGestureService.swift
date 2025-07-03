//
//  MultiAgentGestureService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/MultiAgentGestureService.swift
//
//  MultiAgentGestureService.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Relays gesture events between multiple devices.

import Foundation
import Combine

public final class MultiAgentGestureService {
    public static let shared = MultiAgentGestureService()
    private init() {}

    /// Publishes raw gesture JSON strings.
    public let gesturePublisher = PassthroughSubject<String, Never>()

    /// Send a gesture JSON to all connected peers.
    public func send(_ gestureJSON: String) {
        // TODO: send over ContinuityTransport
        gesturePublisher.send(gestureJSON)
    }

    /// Subscribe to incoming gestures.
    public func subscribe(_ handler: @escaping (String) -> Void) -> AnyCancellable {
        gesturePublisher.sink(receiveValue: handler)
    }
}
