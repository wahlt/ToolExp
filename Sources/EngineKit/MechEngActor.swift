//
//  MechEngActor.swift
//  EngineKit
//
//  Specification:
//  • Mechanical actor that runs physics via FysEngActor.
//  • Interfaces with RepStruct to update node positions.
//
//  Discussion:
//  MechEngActor receives “apply” intents, loads graph data,
//  runs simulation, then writes back updated positions.
//
//  Rationale:
//  • Separates raw physics from Rep-level orchestration.
//  • Leverages actor isolation for thread safety.
//
//  Dependencies: RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit

public actor MechEngActor {
    public static let shared = MechEngActor()
    private init() {}

    /// Applies physics step for the given Rep ID.
    public func apply(_ payload: Any?) async throws {
        guard let repID = payload as? UUID else { return }
        var (nodes, edges) = try await RepStruct.shared.loadGraph(for: repID)
        await FysEngActor.shared.simulate(nodes: &nodes, edges: edges, delta: 1/60)
        try await RepStruct.shared.updatePositions(repID: repID, nodes: nodes)
    }
}
