//
//  AIMentor.swift
//  AIKit
//
//  Specification:
//  • Singleton façade to OpenAIAdaptor for AI-driven mentoring.
//  • Enforces rate-limits and serializes requests to avoid API throttling.
//  • Parses JSON responses into plain text and handles errors gracefully.
//
//  Discussion:
//  We want “in-situ” AI advice with minimal latency. Using a singleton
//  centralizes network configuration but requires care to avoid blocking
//  the main thread. Rate-limiting prevents overloading the AI service.
//
//  Rationale:
//  • Singleton ensures one URLSession and one rate-limit tracker.
//  • DispatchQueue with qos .userInitiated prioritizes UX responsiveness.
//  • Encapsulation hides networking details behind a simple ask(_:).
//
//  Dependencies: IntegrationKit.OpenAIAdaptor
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import IntegrationKit

public final class AIMentor {
    /// Shared singleton instance.
    public static let shared = AIMentor()
    private init() {}

    /// Queue to serialize and throttle requests.
    private let queue = DispatchQueue(label: "AIKit.AIMentorQueue", qos: .userInitiated)
    private var lastRequest: Date?
    private let minInterval: TimeInterval = 1.0  // seconds

    /// Ask the mentor a question.
    ///
    /// - Parameters:
    ///   - prompt: Natural-language question or context.
    ///   - completion: Returns AI text or Error.
    public func ask(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let now = Date()
            if let last = self.lastRequest, now.timeIntervalSince(last) < self.minInterval {
                let delay = self.minInterval - now.timeIntervalSince(last)
                self.queue.asyncAfter(deadline: .now() + delay) {
                    self.send(prompt, completion: completion)
                }
            } else {
                self.send(prompt, completion: completion)
            }
        }
    }

    /// Internal network call via OpenAIAdaptor.
    private func send(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        lastRequest = Date()
        let params = OpenAICompletionParameters(
            model: "gpt-4-mini",
            prompt: prompt,
            maxTokens: 256,
            temperature: 0.7,
            topP: 1.0
        )
        OpenAIAdaptor.shared.complete(parameters: params) { result in
            switch result {
            case .success(let resp):
                if let text = resp.choices.first?.text {
                    let tidy = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    completion(.success(tidy))
                } else {
                    let err = NSError(
                        domain: "AIKit.AIMentor",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Malformed AI response"]
                    )
                    completion(.failure(err))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
