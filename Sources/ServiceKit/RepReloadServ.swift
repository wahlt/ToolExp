//
//  RepReloadServ.swift
//  ServiceKit
//
//  Specification:
//  • Reloads Rep graphs from JSON or remote sources.
//  • Posts notification upon completion for UI to update.
//
//  Discussion:
//  Useful for live-coding and hot-swap demos in ToolDev.
//
//  Rationale:
//  • Decouple reload logic from controllers.
//  • NotificationCenter ensures loose coupling.
//
//  Dependencies: Foundation, RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit

public class RepReloadServ {
    public static let shared = RepReloadServ()
    private init() {}

    public static let reloadNotification = Notification.Name("RepReloaded")

    /// Reloads a rep from JSON data and notifies observers.
    public func reload(repID: UUID, from data: Data) {
        if let rep = try? RepSerializer.fromJSON(data) {
            Task {
                await RepStructStore.shared.updateCells(repID: repID, cells: rep.cells)
                NotificationCenter.default.post(name: RepReloadServ.reloadNotification, object: repID)
            }
        }
    }
}
