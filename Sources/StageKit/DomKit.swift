//
//  DomKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// DomKit.swift
// StageKit — Defines Dominions and SwiftUI selector.
//
// (Reprinted to ensure you have the current edition with SwiftData integration if needed.)
//

import SwiftUI
import SwiftData

public enum Dominion: String, CaseIterable, Identifiable {
    public var id: String { rawValue }
    case rep = "Rep"
    case project = "Project"
    case asset = "Asset"
}

/// For each Dominion, define available Stages.
public enum Stage: String, CaseIterable, Identifiable {
    public var id: String { rawValue }
    case craft = "Craft"
    case trial = "Trial"
    case inspect = "Inspect"
}

/// SwiftUI list for selecting the current Dominion.
public struct DominionView: View {
    @EnvironmentObject var stageMng: StageMng
    
    public var body: some View {
        List(Dominion.allCases) { dom in
            Button(dom.rawValue) {
                stageMng.currentDominion = dom
                stageMng.loadDefaultRep()
            }
        }
    }
}
