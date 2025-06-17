//
//  Help.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// Help.swift
// AIKit — In-app Help system, powered by AI or static topics.
//
// Provides contextual help based on keywords or AI fallback.
//

import Foundation

/// A single help topic entry.
public struct HelpTopic {
    /// Short identifier, e.g. "creating_cells"
    public let id: String
    /// Human-readable title.
    public let title: String
    /// Detailed description or markdown.
    public let content: String
}

/// The help system, offering static topics and AI-backed answers.
public actor HelpSystem {
    private let topics: [HelpTopic]
    private let aiService: DefaultAIService

    /// Initialize with built-in topics and optional AI fallback.
    public init(
        topics: [HelpTopic] = [],
        aiService: DefaultAIService = .init()
    ) {
        self.topics = topics
        self.aiService = aiService
    }

    /// Fetch a static topic by ID.
    public func topic(by id: String) -> HelpTopic? {
        return topics.first { $0.id == id }
    }

    /// Provide help for an arbitrary query, using AI if no static topic matches.
    public func query(_ text: String) async throws -> String {
        if let topic = topic(by: text) {
            return topic.content
        }
        // Fallback to AI
        let prompt = "Help me with Tool-exp: \(text)"
        return try await aiService.complete(prompt: prompt, maxTokens: 200)
    }
}
