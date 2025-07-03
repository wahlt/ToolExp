// Sources/CloudSyncKit/WebSocketContinuityTransport.swift
//
// WebSocket-based transport for streaming CRDT deltas between peers.
// Conforms to the `ContinuityTransport` protocol defined in ContinuityKit.

import Foundation
#if canImport(ContinuityKit)
import ContinuityKit
#else
#error("ContinuityKit target must be added to Package.swift")
#endif

/// Transports binary-encoded RepStruct edits over a WebSocket link.
public final class WebSocketContinuityTransport: ContinuityTransport {
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?

    /// Initialize with the WebSocket URL
    public init(url: URL) {
        self.url = url
    }

    /// Open connection and send raw data.
    public func send(_ data: Data) async throws {
        if webSocketTask == nil {
            let session = URLSession(configuration: .default)
            webSocketTask = session.webSocketTask(with: url)
            webSocketTask?.resume()
        }
        let message = URLSessionWebSocketTask.Message.data(data)
        try await webSocketTask!.send(message)
    }

    /// Receive raw data from the socket.
    public func receive() async throws -> Data {
        guard let task = webSocketTask else {
            throw URLError(.notConnectedToInternet)
        }
        let message = try await task.receive()
        switch message {
        case .data(let d):   return d
        case .string(let s): return Data(s.utf8)
        @unknown default:     throw URLError(.cannotDecodeContentData)
        }
    }
}
