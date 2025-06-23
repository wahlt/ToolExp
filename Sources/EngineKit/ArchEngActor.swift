//
//  ArchEngActor.swift
//  EngineKit
//
//  Specification:
//  • Actor that interprets high-level execution intents.
//  • Routes each intent to the appropriate subsystem actor.
//
//  Discussion:
//  Decouples intent dispatch from UI. Intents can represent
//  physics updates, data queries, rendering commands, etc.
//
//  Rationale:
//  • Actor enforces thread-safety for shared state.
//  • Routing logic centralizes command handling.
//
//  Dependencies: RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit

public actor ArchEngActor {
    public static let shared = ArchEngActor()

    /// Dispatches an intent by name to subsystem actors.
    ///
    /// - Parameters:
    ///   - intent: E.g. "physics", "data", "render".
    ///   - payload: Optional context-specific data.
    public func handle(intent: String, payload: Any?) async throws {
        switch intent {
        case "physics":
            try await RepMechActor.shared.apply(payload)
        case "data":
            // Future: DataServActor.shared.query(payload)
            break
        case "render":
            // Future: RepRenderer.shared.render(payload)
            break
        default:
            throw NSError(
                domain: "EngineKit.ArchEngActor",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Unknown intent \(intent)"]
            )
        }
    }
}
