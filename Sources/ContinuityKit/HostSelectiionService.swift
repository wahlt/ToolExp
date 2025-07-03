//
//  HostSelectiionService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/HostSelectionService.swift
//
//  HostSelectionService.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Manages which peer is the session host.

import Foundation

public final class HostSelectionService {
    public static let shared = HostSelectionService()
    private init() {}

    public enum Role { case host, client }

    private(set) public var role: Role = .client

    /// Elect yourself as host.
    public func becomeHost() {
        role = .host
        NotificationCenter.default.post(
            name: .hostDidChange, object: role
        )
    }

    /// Resign host duties.
    public func resignHost() {
        role = .client
        NotificationCenter.default.post(
            name: .hostDidChange, object: role
        )
    }
}

public extension Notification.Name {
    static let hostDidChange = Notification.Name("HostSelectionService.hostDidChange")
}
