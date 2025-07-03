//
//  ZeroCopyContinuityTansport.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/ZeroCopyContinuityTransport.swift
//
//  ZeroCopyContinuityTransport.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  In-memory shared buffer transport for same-process agents.

import Foundation

public final class ZeroCopyContinuityTransport: ContinuityTransport {
    private var buffer = Data()

    public init() {}

    public func send(_ data: Data) {
        buffer = data
    }

    public func receive(_ handler: @escaping (Data) -> Void) {
        handler(buffer)
    }
}
