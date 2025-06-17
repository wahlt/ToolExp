//
//  ContinuityServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ContinuityServ.swift
// ServiceKit — Multi-device / multi-host state sync via CloudKit & MultipeerConnectivity.
//
// Broadcasts/receives graph deltas and UI events to keep multiple Devices & Agents in sync.
//

import Foundation
import CloudKit
import MultipeerConnectivity
import Combine
import RepKit

public actor ContinuityServ: NSObject {
    // MARK: – Types

    public enum Message {
        case repDelta(Data)      // Encoded RepUpdate
        case uiEvent(Data)       // Encoded UI action
    }

    // MARK: – Properties

    private let container = CKContainer.default()
    private let database = CKContainer.default().privateCloudDatabase
    private let session = MCSession(peer: MCPeerID(displayName: UIDevice.current.name))
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser

    public let incoming = PassthroughSubject<Message, Never>()

    // MARK: – Initialization

    public override init() {
        advertiser = MCNearbyServiceAdvertiser(
            peer: session.myPeerID,
            discoveryInfo: nil,
            serviceType: "tool-cont"
        )
        browser = MCNearbyServiceBrowser(
            peer: session.myPeerID,
            serviceType: "tool-cont"
        )
        super.init()
        session.delegate = self
        advertiser.delegate = self
        browser.delegate = self
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }

    // MARK: – Public API

    /// Broadcast a RepUpdate delta to all peers & CloudKit.
    public func broadcast(repDelta: RepUpdate) async throws {
        let data = try JSONEncoder().encode(repDelta)
        // 1. Send via Multipeer
        try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        // 2. Save to CloudKit
        let record = CKRecord(recordType: "RepDelta")
        record["delta"] = data as NSData
        try await database.save(record)
    }
}

// MARK: – MCSessionDelegate

extension ContinuityServ: MCSessionDelegate {
    public func session(_ session: MCSession,
                        peer peerID: MCPeerID,
                        didChange state: MCSessionState) {}

    public func session(_ session: MCSession,
                        didReceive data: Data,
                        fromPeer peerID: MCPeerID) {
        // Attempt decode as RepUpdate or UIEvent
        if let delta = try? JSONDecoder().decode(RepUpdate.self, from: data) {
            incoming.send(.repDelta(data))
        } else {
            incoming.send(.uiEvent(data))
        }
    }

    // Unused delegate stubs:
    public func session(_ session: MCSession,
                        didReceive stream: InputStream,
                        withName streamName: String,
                        fromPeer peerID: MCPeerID) {}
    public func session(_ session: MCSession,
                        didStartReceivingResourceWithName resourceName: String,
                        fromPeer peerID: MCPeerID,
                        with progress: Progress) {}
    public func session(_ session: MCSession,
                        didFinishReceivingResourceWithName resourceName: String,
                        fromPeer peerID: MCPeerID,
                        at localURL: URL?,
                        withError error: Error?) {}
}

// MARK: – MCNearbyServiceAdvertiserDelegate & BrowserDelegate

extension ContinuityServ: MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                           didReceiveInvitationFromPeer peerID: MCPeerID,
                           withContext context: Data?,
                           invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }

    public func browser(_ browser: MCNearbyServiceBrowser,
                        foundPeer peerID: MCPeerID,
                        withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    public func browser(_ browser: MCNearbyServiceBrowser,
                        lostPeer peerID: MCPeerID) {}
}
