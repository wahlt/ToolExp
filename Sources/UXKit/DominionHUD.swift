//
//  DominionHUD.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

import SwiftUI
import StageKit   // for StageMng, Dominion & Stage

/// Heads-up display of current Dominion & Stage.
public struct DominionHUD: View {
    @EnvironmentObject var stageMng: StageMng

    public var body: some View {
        HStack {
            Text("Dominion: \(stageMng.currentDominion.rawValue)")
            Spacer()
            Text("Stage:     \(stageMng.currentStage.rawValue)")
        }
        .padding(8)
        .background(Color.black.opacity(0.6))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
