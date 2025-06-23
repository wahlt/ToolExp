//
//  ContinuityServ.swift
//  ServiceKit
//
//  Specification:
//  • Manages cross-device state synchronization for Tool.
//  • Uses MultipeerConnectivity to discover peers and share Rep diffs.
//
//  Discussion:
//  SuperContinuity demands live sync across iPad, Mac, Vision devices.
//  This service handles peer discovery, session management, and data exchange.
//
//  Rationale:
//  • MultipeerConnectivity provides encryption and reliable transport.
//  • Notifications on receipt trigger local state updates.
//
//  Dependencies: MultipeerConnectivity
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class ContinuityServ: NSObject {
    public static let shared = ContinuityServ()

    private let peerID      = MCPeerID(displayName: UIDevice.current.name)
    private let session:    MCSession
    private let advertiser: MCNearbyServiceAdvertiser

    private override init() {
        session    = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        advertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: nil,
            serviceType: "tool-continuity"
        )
        super.init()
        session.delegate    = self
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }

    /// Sends a Rep-diff payload to all connected peers.
    public func sendRepDiff(_ data: Data) {
        guard !session.connectedPeers.isEmpty else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

extension ContinuityServ: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    public func session(_ session: MCSession,
                        didReceive data: Data,
                        fromPeer peerID: MCPeerID)
    {
        // Handle incoming Rep diffs...
    }
    public func session(_: MCSession,
                        didReceive _: InputStream,
                        withName _: String,
                        fromPeer _: MCPeerID) {}
    public func session(_: MCSession,
                        didStartReceivingResourceWithName _: String,
                        fromPeer _: MCPeerID,
                        with _: Progress) {}
    public func session(_: MCSession,
                        didFinishReceivingResourceWithName _: String,
                        fromPeer _: MCPeerID,
                        at _: URL?,
                        withError _: Error?) {}
    public func advertiser(_: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("ContinuityServ advertise error:", error)
    }
    public func advertiser(_: MCNearbyServiceAdvertiser,
                           didReceiveInvitationFromPeer _: MCPeerID,
                           withContext _: Data?,
                           invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        invitationHandler(true, session)
    }
}
