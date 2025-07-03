//
//  DataServ.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-23.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Core registration and setup for SwiftData models.
//

import Foundation
import SwiftData

public struct DataServ {
    /// Call this once at app launch to register all models.
    public static func registerModels() {
        // Example:
        // ModelRegistry.register(RepVersionEntity.self)
        ModelRegistry.registerAll()
    }
}
