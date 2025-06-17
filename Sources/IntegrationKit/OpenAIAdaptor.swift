//
//  OpenAIAdaptor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// OpenAIAdaptor.swift
// IntegrationKit — Adapts the OpenAI API for conversational & completion services.
//

import Foundation
import OpenAIKit

/// Provides easy access to text & chat completions.
public actor OpenAIAdaptor {
    private let client: OpenAIClient

    /// Initialize with your API key.
    public init(apiKey: String) {
        client = OpenAIClient(apiKey: apiKey)
    }

    /// Simple text completion.
    public func completeText(prompt: String, model: Model = .gpt4All) async throws -> String {
        let response = try await client.text.completions.create(
            model: model,
            prompt: prompt,
            maxTokens: 256
        )
        return response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    /// Chat-style completion with system/user roles.
    public func chatCompletion(
        messages: [ChatMessage],
        model: Model = .gpt4All
    ) async throws -> ChatMessage {
        let response = try await client.chat.completions.create(
            model: model,
            messages: messages
        )
        return response.choices.first!.message
    }
}
