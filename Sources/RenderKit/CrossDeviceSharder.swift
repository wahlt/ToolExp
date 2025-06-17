//
//  CrossDeviceSharder.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// CrossDeviceSharder.swift
// RenderKit — Distributes GPU compute across peer Apple devices.
//
// Responsibilities:
//  • Partition large MLX or Metal workloads.
//  • Send compute buffers & commands to nearby devices (Multipeer + MLX).
//  • Collect & merge results via argument buffers.
//

import Foundation
import MultipeerConnectivity
import MLXIntegration

public final class CrossDeviceSharder: NSObject {
    public static let shared = CrossDeviceSharder()

    private let session: MCSession
    private let peer: MCPeerID

    private override init() {
        self.peer = .init(displayName: Host.current().localizedName ?? "Device")
        self.session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }

    /// Shard a large graph compute across available peers.
    public func shardCompute(
        graph: MLX.Graph,
        inputBuffers: [MLX.Buffer],
        completion: @escaping ([MLX.Buffer]) -> Void
    ) {
        // TODO:
        // 1) Serialize graph & buffers
        // 2) Send to peers via session.send(...)
        // 3) Execute locally & remotely
        // 4) On return, merge buffers and call completion
    }
}

extension CrossDeviceSharder: MCSessionDelegate {
    // TODO: implement peer connect/disconnect & data receipt
    public func session(_: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    public func session(_: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    public func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}
    public func session(_: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {}
    public func session(_: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?, withError _: Error?) {}
}
