//
//  OpenAIAdaptor.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/OpenAIAdaptor.swift
//
//  OpenAIAdaptor.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Sends text completion requests to the OpenAI API.
//

import Foundation

/// Adaptor for making OpenAI completion calls.
public final class OpenAIAdaptor: BridgeAdaptor {
    public static let name = "OpenAIAdaptor"
    private let session: URLSession
    private let apiKey: String

    /// Initialize with your secret API key.
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    /// Sends `prompt`, returns first chosen text via callback.
    public func complete(
        prompt: String,
        model: String = "gpt-4",
        maxTokens: Int = 256,
        completion: @escaping (String?) -> Void
    ) {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Bearer \(apiKey)",
                     forHTTPHeaderField: "Authorization")
        req.setValue("application/json",
                     forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = [
            "model": model,
            "prompt": prompt,
            "max_tokens": maxTokens,
            "n": 1
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)
        session.dataTask(with: req) { data, _, error in
            guard error == nil,
                  let data = data,
                  let resp = try? JSONDecoder()
                      .decode(CompletionResponse.self,
                              from: data),
                  let first = resp.choices.first
            else {
                completion(nil)
                return
            }
            completion(first.text)
        }.resume()
    }

    /// Response structure per OpenAI’s API spec.
    private struct CompletionResponse: Decodable {
        let choices: [Choice]
        struct Choice: Decodable {
            let text: String
            let index: Int
        }
    }
}
