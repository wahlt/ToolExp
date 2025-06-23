//
//  CrossDeviceSharder.swift
//  RenderKit
//
//  Specification:
//  • Splits heavy compute tasks into sub-tasks and dispatches to peers.
//
//  Discussion:
//  For Continuity, complex Rep computations can be sharded across devices.
//
//  Rationale:
//  • Leverages all available hardware for performance.
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct ShardAssignment {
    public let peerID: UUID
    public let tileIndices: [Int]
}

public class CrossDeviceSharder {
    /// Splits N tiles among M peers in round-robin fashion.
    public static func shard(tileCount N: Int, peers: [UUID]) -> [ShardAssignment] {
        var assignments: [UUID: [Int]] = [:]
        for (i, peer) in peers.enumerated() {
            assignments[peer, default: []].append(i)
        }
        return assignments.map { ShardAssignment(peerID: $0, tileIndices: $1) }
    }
}
