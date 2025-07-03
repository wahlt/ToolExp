//
//  CloudSyncService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/CloudSyncKit/CloudSyncService.swift
//
//  CloudSyncService.swift
//  CloudSyncKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Synchronizes RepStruct changes across devices via WebSocket.

import Foundation

public final class CloudSyncService {
    public static let shared = CloudSyncService()
    private init() {}

    private var webSocket: URLSessionWebSocketTask?

    /// Connects to the sync server at the given URL.
    public func connect(to url: URL) {
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        listen()
    }

    /// Listens for incoming messages indefinitely.
    private func listen() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let msg):
                if case .string(let text) = msg {
                    // handle incoming JSON-of-RepStruct
                    print("Sync recv:", text)
                }
            case .failure(let err):
                print("WebSocket error:", err)
            }
            self?.listen()
        }
    }

    /// Sends a JSON string out to all peers.
    public func broadcast(_ json: String) {
        webSocket?.send(.string(json)) { error in
            if let e = error {
                print("Sync send error:", e)
            }
        }
    }
}// Sources/CloudSyncKit/CloudSyncService.swift
//
//  CloudSyncService.swift
//  CloudSyncKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Synchronizes RepStruct changes across devices via WebSocket.

import Foundation

public final class CloudSyncService {
    public static let shared = CloudSyncService()
    private init() {}

    private var webSocket: URLSessionWebSocketTask?

    /// Connects to the sync server at the given URL.
    public func connect(to url: URL) {
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        listen()
    }

    /// Listens for incoming messages indefinitely.
    private func listen() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let msg):
                if case .string(let text) = msg {
                    // handle incoming JSON-of-RepStruct
                    print("Sync recv:", text)
                }
            case .failure(let err):
                print("WebSocket error:", err)
            }
            self?.listen()
        }
    }

    /// Sends a JSON string out to all peers.
    public func broadcast(_ json: String) {
        webSocket?.send(.string(json)) { error in
            if let e = error {
                print("Sync send error:", e)
            }
        }
    }
}
