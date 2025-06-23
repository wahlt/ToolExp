// File: Sources/RepKit/Cell.swift
//  RepKit
//
//  Specification:
//  • A single graph “cell” holding ports, metadata, position, and velocity.
//  • Conforms to Codable, Equatable, and Sendable for safe actor use.
//
//  Discussion:
//  The `data` dictionary uses [String:AnyCodable], which is now Sendable by extension above.
//  Each cell may list outgoing ports to other cell UUIDs for graph traversal and physics.
//
//  Rationale:
//  • Value type protects against unintended shared state.
//  • Sendable conformance silences actor isolation warnings when cells cross actor boundaries.
//  • Codable conformance supports persistence and replication.
//
//  TODO:
//  • Add additional physical properties (mass, charge) to support more complex simulations.
//  • Validate port UUIDs against existing cells in RepIntegrityChecker.
//
//  Dependencies: Foundation, simd, AnyCodable
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import simd

public struct Cell: Codable, Equatable, Sendable {
    /// Unique identifier for this cell
    public let id: UUID
    /// Named output ports mapping to target cell UUIDs
    public var ports: [String: UUID]
    /// Arbitrary key/value metadata attached to this cell
    public var data: [String: AnyCodable]
    /// Current 2D position for physics/rendering
    public var position: SIMD2<Float>
    /// Current 2D velocity for physics integration
    public var velocity: SIMD2<Float>

    public init(
        id: UUID,
        ports: [String: UUID] = [:],
        data: [String: AnyCodable] = [:],
        position: SIMD2<Float> = .zero,
        velocity: SIMD2<Float> = .zero
    ) {
        self.id = id
        self.ports = ports
        self.data = data
        self.position = position
        self.velocity = velocity
    }
}
