//
//  SpatialAwarenessService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/SpatialAwarenessService.swift
//
//  SpatialAwarenessService.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Tracks peer device positions and broadcasts updates.

import Foundation
import simd
import Combine

public final class SpatialAwarenessService {
    public static let shared = SpatialAwarenessService()
    private init() {}

    private let subject = PassthroughSubject<[String: float4x4], Never>()

    /// Publish latest transforms keyed by peer ID.
    public var publisher: AnyPublisher<[String: float4x4], Never> {
        subject.eraseToAnyPublisher()
    }

    /// Update local transform and broadcast.
    public func updateTransform(_ transform: float4x4) {
        // TODO: send over transport
        subject.send(["local": transform])
    }
}
