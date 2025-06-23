//
//  OpenAIAdaptor.swift
//  IntegrationKit
//
//  Specification:
//  • Low-level adaptor to call OpenAI Completion API via URLSession.
//  • Handles JSON encode/decode, API keys, and error mapping.
//
//  Discussion:
//  Direct networking for AI must remain separate from AIMentor’s logic.
//
//  Rationale:
//  • Encapsulate endpoint, headers, and auth in one place.
//  • Return typed Swift models for response handling.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public struct OpenAICompletionParameters: Codable {
    public let model: String
    public let prompt: String
    public let maxTokens: Int
    public let temperature: Double
    public let topP: Double
}

public struct OpenAIChoice: Codable {
    public let text: String
}

public struct OpenAICompletionResponse: Codable {
    public let choices: [OpenAIChoice]
}

public class OpenAIAdaptor {
    public static let shared = OpenAIAdaptor()
    private init() {}

    private let apiKey: String = {
        return Bundle.main.object(forInfoDictionaryKey: "OpenAIAPIKey") as? String ?? ""
    }()

    /// Sends a completion request.
    public func complete(
        parameters: OpenAICompletionParameters,
        completion: @escaping (Result<OpenAICompletionResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            completion(.failure(NSError(domain: "OpenAIAdaptor", code: -1, userInfo: nil)))
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            req.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            completion(.failure(error)); return
        }

        let task = URLSession.shared.dataTask(with: req) { data, resp, err in
            if let e = err { completion(.failure(e)); return }
            guard let d = data else {
                completion(.failure(NSError(domain: "OpenAIAdaptor", code: -2, userInfo: nil)))
                return
            }
            do {
                let result = try JSONDecoder().decode(OpenAICompletionResponse.self, from: d)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
