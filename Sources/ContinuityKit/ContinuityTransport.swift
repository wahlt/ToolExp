//
//  ContinuityTransport.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/ContinuityTransport.swift
//
//  ContinuityTransport.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Protocol for sending/receiving binary messages across devices.

import Foundation

public protocol ContinuityTransport {
    /// Send a data payload to the remote peer(s).
    func send(_ data: Data)

    /// Asynchronously receive data from remote peer(s).
    func receive(_ handler: @escaping (Data) -> Void)
}
