//
//  DeviceCapabilityService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/ContinuityKit/DeviceCapabilityService.swift
//
//  DeviceCapabilityService.swift
//  ContinuityKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Reports on runtime device GPU/CPU capabilities.

import Foundation
import Metal

public final class DeviceCapabilityService {
    public static let shared = DeviceCapabilityService()
    private init() {}

    public var maxThreadsPerThreadgroup: Int? {
        MTLCreateSystemDefaultDevice()?.maxThreadsPerThreadgroup.width
    }

    public var supportsFamily5: Bool {
        guard let device = MTLCreateSystemDefaultDevice() else { return false }
        return device.supportsFamily(.apple5)
    }
}
