//
//  StageMng.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// StageMng.swift
// StageKit — Manages current Dominion, Stage, and loaded Rep.
//

import Foundation
import RepKit
import SwiftUI
import SwiftData

public final class StageMng: ObservableObject {
    @Published public var currentDominion: Dominion = .rep
    @Published public var currentStage: Stage = .craft
    @Published public var currentRep: RepStruct = RepStruct(name: "Untitled")

    private let dataServ = DataServ()

    public init() {}

    /// Load or create the default Rep for the selected Dominion.
    public func loadDefaultRep() {
        switch currentDominion {
        case .rep:
            currentRep = RepStruct(name: "Untitled Rep")
        case .project:
            // TODO: ProjectRep fallback
            currentRep = RepStruct(name: "Untitled Project")
        case .asset:
            // TODO: AssetRep fallback
            currentRep = RepStruct(name: "Untitled Asset")
        }
    }

    /// Apply a RepUpdate delta to the current Rep.
    public func apply(_ update: RepUpdate) {
        if let newRep = try? update.apply(to: currentRep) {
            currentRep = newRep
        }
    }
}
