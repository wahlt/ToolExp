//
//  SettingsEntity.swift
//  ServiceKit
//
//  Specification:
//  • Model for persistent app settings via DataServ.
//  • Codable for JSON-backed storage: lastRep, lastStage, UI toggles.
//
//  Discussion:
//  Tool’s preferences (e.g. last open rep, SuperStage) are stored here.
//
//  Rationale:
//  • Leverage DataServ’s Persistable API for simplicity.
//  • Single record avoids array management overhead.
//
//  Dependencies: Foundation, DataServ
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import DataServ

public struct SettingsEntity: Persistable {
    public static var storageKey: String { "settings" }
    public var lastRep:   UUID?
    public var lastStage: String?
    public var showGrid:  Bool
    
    public init(lastRep: UUID? = nil,
                lastStage: String? = nil,
                showGrid: Bool = true)
    {
        self.lastRep   = lastRep
        self.lastStage = lastStage
        self.showGrid  = showGrid
    }
    
    public static func load() throws -> SettingsEntity {
        let all = try DataServ.shared.loadAll(SettingsEntity.self)
        return all.first ?? SettingsEntity()
    }
    
    public func save() throws {
        try DataServ.shared.saveAll([self], as: SettingsEntity.self)
    }
}
