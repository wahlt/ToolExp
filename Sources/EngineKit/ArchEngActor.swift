//
//  ArchEngActor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ArchEngActor.swift
// EngineKit — Architecture exploration actor.
//
// Uses trait‐based heuristics and pattern catalogs to propose
// alternative Rep topologies (graph morphisms).
//

import Foundation
import RepKit

/// An actor that generates architectural variants of a Rep.
public final class ArchEngActor {
    /// Propose variants on the given Rep by applying each known pattern.
    ///
    /// - Parameter rep: the original `RepStruct`.
    /// - Returns: an array of new `RepStruct` instances,
    ///   each transformed according to one architectural pattern.
    public func proposeVariants(of rep: RepStruct) -> [RepStruct] {
        // 1) Fetch catalog of patterns
        let patterns = ArchEngDescriptor.availablePatterns()

        // 2) For each pattern, apply its transformation
        return patterns.map { pattern in
            apply(pattern: pattern, to: rep)
        }
    }

    /// Internal helper to apply a single pattern.
    private func apply(pattern: ArchPattern, to rep: RepStruct) -> RepStruct {
        var modified = rep

        switch pattern.name {
        case "Layered":
            // TODO: reorganize nodes into sorted layers based on depth
            break
        case "HubAndSpoke":
            // TODO: pick highest‐degree node as hub, connect all others
            break
        default:
            // Unknown pattern: return rep unmodified
            break
        }

        // Update the name to reflect the variant
        modified.name = "\(rep.name)-\(pattern.name)"
        return modified
    }
}
