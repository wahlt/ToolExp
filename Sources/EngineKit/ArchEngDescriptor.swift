//
//  ArchEngDescriptor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ArchEngDescriptor.swift
// EngineKit — Describes architectural patterns for Reps.
//
// Maintains a registry of named graph‐transformation patterns.
//

import Foundation

/// A named architecture pattern with a human‐readable description.
public struct ArchPattern {
    /// Unique name identifier for the pattern.
    public let name: String
    /// A short description of what the pattern does.
    public let description: String
}

/// Descriptor providing access to built‐in patterns.
public struct ArchEngDescriptor {
    /// List all available patterns.
    public static func availablePatterns() -> [ArchPattern] {
        return [
            ArchPattern(
                name: "Layered",
                description: "Organize nodes into sequential layers by hop‐distance."
            ),
            ArchPattern(
                name: "HubAndSpoke",
                description: "Designate one node as hub and connect all others as its spokes."
            ),
            // TODO: Add more advanced patterns (Tree, Mesh, Modular, etc.)
        ]
    }
}
