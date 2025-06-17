//
//  ContentView.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ContentView.swift
// ToolApp — Root SwiftUI view with FourPaneLayout & gesture overlay.
//

import SwiftUI
import StageKit
import UXKit

struct ContentView: View {
    @EnvironmentObject var stageMng: StageMng

    var body: some View {
        HSplitView {
            // Dominion selector
            DominionView()
                .frame(minWidth: 200)
                .border(Color.gray)

            // Four-pane tool UI
            FourPaneLayout {
                CarouselView()
                PropagateView()
                CraftView()
                TrialView()
            }
        }
        .onAppear { stageMng.loadDefaultRep() }
        // Overlay gesture & performance indicators
        .overlay(GestureIndicatorOverlay())
        .overlay(FPSCounterOverlay())
    }
}
