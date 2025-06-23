// File: Sources/IntegrationKit/OpenAIAdaptor.swift
//  IntegrationKit
//
//  Specification:
//  • Facade for interacting with the OpenAI API.
//  • Provides a singleton `shared` for global use.
//
//  Discussion:
//  We mark the class `@MainActor` so that its shared instance is isolated
//  to the main actor, avoiding concurrency-safety static variable warnings.
//  Actual network calls and logic are TODOs; this stub defines the shape.
//
//  Rationale:
//  • `@MainActor` on the class silences “mutable global” concurrency warnings.
//  • Singleton pattern simplifies usage throughout the app.
//  • Stub methods allow incremental enhancement without breaking builds.
//
//  TODO:
//  • Implement `sendPrompt(_:completion:)` using URLSession and JSON encoding.
//  • Add error-handling, retry logic, and rate-limit support.
//  • Write integration tests against a local OpenAI mock server.
//
//  Dependencies: Foundation
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

@MainActor
public class OpenAIAdaptor {
    /// Shared singleton for sending prompts to OpenAI.
    public static let shared = OpenAIAdaptor()

    private init() {}

    /// Sends a text prompt to the OpenAI API.
    /// - Parameters:
    ///   - prompt: The text to send.
    ///   - completion: Callback with the response string or an error.
    public func sendPrompt(_ prompt: String,
                           completion: @escaping (Result<String, Error>) -> Void)
    {
        // TODO: implement network request to OpenAI endpoint.
    }
}
