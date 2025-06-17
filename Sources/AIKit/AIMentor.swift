//
//  AIMentor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AIMentor.swift
// AIKit — The top-level AI coach, orchestrating lower-level AI helpers.
//
// Uses OpenAIAdaptor from BridgeKit to generate context-aware suggestions.
// Ultimately drives in-app coaching, assisted modeling, and “gut-feel” shortcuts.
//

import Foundation
import RepKit
import BridgeKit

/// Protocol defining basic AI suggestion capabilities.
public protocol AIMentorProtocol {
    /// Given the current Rep and optional user context, produce a suggestion.
    /// - Parameters:
    ///   - rep: the current RepStruct
    ///   - context: optional free-form user or UI context
    /// - Returns: a human-readable suggestion
    func suggestNextAction(for rep: RepStruct, context: String?) async throws -> String
}

/// The “mentor” actor that coordinates AI workflows.
public actor AIMentor: AIMentorProtocol {
    private let aiService: OpenAIAdaptor

    /// Initialize with a shared OpenAI adaptor.
    public init(aiService: OpenAIAdaptor = .shared) {
        self.aiService = aiService
    }

    /// Produce a suggestion by prompting the AI with Rep state and context.
    public func suggestNextAction(for rep: RepStruct, context: String? = nil) async throws -> String {
        // 1) Serialize rep summary
        let summary = "Rep '\(rep.name)' has \(rep.cells.count) cells."
        // 2) Build prompt
        var prompt = """
        You are an AI mentor for a graphical modeling tool.
        The current scene: \(summary)
        """
        if let ctx = context {
            prompt += "\nUser context: \(ctx)"
        }
        prompt += "\nSuggest a next action the user can take."
        // 3) Send to AI
        let response = try await aiService.complete(prompt: prompt, maxTokens: 150)
        return response.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
