//
//  AIKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AIKit.swift
// AIKit — Core AI service definitions and utilities.
//
// Defines shared adaptor protocols and a facade over BridgeKit’s adaptors.
//

import Foundation
import BridgeKit

/// Central interface to any AI back-end.
public protocol AIService {
    /// Send a completion request to the AI.
    /// - Parameters:
    ///   - prompt: the human-readable prompt.
    ///   - maxTokens: maximum length of the response.
    /// - Returns: the AI’s text response.
    func complete(prompt: String, maxTokens: Int) async throws -> String
}

/// Default AIService implementation backed by OpenAI.
public struct DefaultAIService: AIService {
    private let adaptor: OpenAIAdaptor

    public init(adaptor: OpenAIAdaptor = .shared) {
        self.adaptor = adaptor
    }

    public func complete(prompt: String, maxTokens: Int) async throws -> String {
        // Forward directly to the OpenAI adaptor.
        return try await adaptor.complete(prompt: prompt, maxTokens: maxTokens)
    }
}
