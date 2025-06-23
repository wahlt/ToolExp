//
//  Help.swift
//  AIKit
//
//  Specification:
//  • Loads and serves Markdown-based help topics.
//  • Provides lookup by topic ID.
//
//  Discussion:
//  In-app help must be fast and offline, so pre-bundle JSON/Markdown.
//  Topics are keyed by ID to decouple storage from UI.
//
//  Rationale:
//  • Simple dictionary lookup offers O(1) retrieval.
//  • Bundled topics avoid runtime network dependency.
//
//  Dependencies: none (Foundation only)
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public class HelpManager {
    private var topics: [String: String] = [:]

    public init() {
        loadBuiltInTopics()
    }

    /// Returns Markdown help for a given ID, or nil.
    public func content(for id: String) -> String? {
        return topics[id]
    }

    /// Loads default topics from a bundled resource.
    private func loadBuiltInTopics() {
        // TODO: Replace with real JSON bundle in production.
        topics["getting_started"] = """
        # Getting Started
        Welcome to Tool! \
        Use one-finger tap to select, two-finger pinch to zoom, \
        and three-finger drag for global transforms.
        """
    }
}
