//
//  Cell.swift
//  RepKit
//
//  Specification:
//  • Fundamental unit of Rep: uniquely identified, stores metadata,
//    ports to other cells, and optional spatial properties.
//
//  Discussion:
//  Cells form the nodes of Rep graphs. They carry arbitrary
//  key/value data and connection ports mapping names→cellIDs.
//
//  Rationale:
//  • Keep minimal to allow extension via traits or facets.
//  • Codable for JSON‐based persistence and network sync.
//
//  Dependencies: Foundation, simd
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import simd

public struct Cell: Codable, Equatable {
    public let id: UUID
    public var data: [String: AnyCodable]
    public var ports: [String: UUID]
    public var position: SIMD3<Float>
    public var velocity: SIMD3<Float>

    public init(id: UUID = UUID(),
                data: [String: AnyCodable] = [:],
                ports: [String: UUID] = [:],
                position: SIMD3<Float> = .zero,
                velocity: SIMD3<Float> = .zero)
    {
        self.id = id
        self.data = data
        self.ports = ports
        self.position = position
        self.velocity = velocity
    }
}
