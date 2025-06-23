// File: ServiceKit/ContinuityServ.swift
//
//  ContinuityServ.swift
//  ServiceKit
//
//  Specification:
//  • Manages cross-device state sync via MultipeerConnectivity.
//  • Cleans up sessions on deinit to avoid retained resources.
//
//  Discussion:
//  Stopping advertising and disconnecting peers when no longer needed
//  prevents leaks and respects battery life.
//
//  Rationale:
//  • Encapsulate resource‐management trade-offs in one place.
//  TODO:
//    – [ ] Revisit trade-offs between perpetual sessions vs. on-demand.
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
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "tool-continuity")
        super.init()
        session.delegate    = self
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }

    deinit {
        advertiser.stopAdvertisingPeer()
        session.disconnect()
    }

    public func sendRepDiff(_ data: Data) {
        guard !session.connectedPeers.isEmpty else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

extension ContinuityServ: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    public func session(_ session: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}
    public func session(_ session: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {}
    public func session(_ session: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?, withError _: Error?) {}
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) { print(error) }
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer _: MCPeerID, withContext _: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}
