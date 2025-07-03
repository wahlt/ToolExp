//
//  WolframBridge.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/WolframBridge.swift
//
//  WolframBridge.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Sends a `RepStruct` JSON to a Wolfram Language endpoint for evaluation.
//

import Foundation
import RepKit

public class WolframBridge: BridgeAdaptor {
    public static let name = "WolframBridge"
    private let session = URLSession.shared
    private let endpoint: URL

    /// Initialize with the REST endpoint for Wolfram evaluation.
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }

    public enum Error: Swift.Error {
        case encodingFailed
        case invalidResponse
    }

    /// Encodes the `RepStruct`, POSTs it, returns text result.
    public func evaluate(
        rep: RepStruct,
        completion: @escaping (Result<String, Swift.Error>) -> Void
    ) {
        guard let data = try? JSONEncoder().encode(rep) else {
            completion(.failure(Error.encodingFailed))
            return
        }
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json",
                     forHTTPHeaderField: "Content-Type")

        session.uploadTask(with: req, from: data) { data, _, err in
            if let err = err {
                completion(.failure(err))
            } else if let d = data,
                      let text = String(data: d, encoding: .utf8) {
                completion(.success(text))
            } else {
                completion(.failure(Error.invalidResponse))
            }
        }.resume()
    }
}
