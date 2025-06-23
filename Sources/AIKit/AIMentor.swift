// File: AIKit/AIMentor.swift
//
//  AIMentor.swift
//  AIKit
//
//  Specification:
//  • Protocol-based façade to OpenAIAdaptor for AI-driven mentoring.
//  • Supports dependency injection for testability.
//
//  Discussion:
//  Swapping the hard-coded singleton for a protocol allows mocking
//  the AI backend in unit tests and future service backends.
//
//  Rationale:
//  • Improves test coverage by decoupling network client.
//  • Keeps API surface identical for callers.
//
//  Dependencies: IntegrationKit.OpenAIAdaptor
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import IntegrationKit

/// Protocol for any AI completion service.
public protocol AICompletionAdapting {
    func complete(
        parameters: OpenAICompletionParameters,
        completion: @escaping (Result<OpenAICompletionResponse, Error>) -> Void
    )
}

/// Protocol for the Mentor façade.
public protocol AIMentorProtocol {
    func ask(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void)
}

/// Concrete Mentor implementation, depends on `AICompletionAdapting`.
public final class AIMentor: AIMentorProtocol {
    /// Publicly replaceable shared instance for DI.
    public static var shared: AIMentorProtocol = AIMentor(adaptor: OpenAIAdaptor.shared)

    private let adaptor: AICompletionAdapting
    private let queue = DispatchQueue(label: "AIKit.AIMentorQueue", qos: .userInitiated)
    private var lastRequest: Date?
    private let minInterval: TimeInterval = 1.0  // seconds

    /// Designated initializer for injecting any AICompleter.
    public init(adaptor: AICompletionAdapting) {
        self.adaptor = adaptor
    }

    /// Ask the mentor a question.
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

    private func send(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        lastRequest = Date()
        let params = OpenAICompletionParameters(
            model: "gpt-4-mini",
            prompt: prompt,
            maxTokens: 256,
            temperature: 0.7,
            topP: 1.0
        )
        adaptor.complete(parameters: params) { result in
            switch result {
            case .success(let resp):
                guard let text = resp.choices.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                    completion(.failure(NSError(domain: "AIKit.AIMentor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Malformed AI response"])))
                    return
                }
                completion(.success(text))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
