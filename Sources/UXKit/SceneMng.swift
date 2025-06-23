//
//  SceneMng.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// SceneMng.swift
// UXKit — Scene-graph viewer & editor component.
//
// Shows nodes and edges in a scrollable, zoomable view.
//

import SwiftUI
import RepKit

public struct SceneMng: View {
    @Binding public var rep: RepStruct

    public init(rep: Binding<RepStruct>) {
        self._rep = rep
    }

    public var body: some View {
        ScrollView([.horizontal, .vertical]) {
            // TODO: render nodes as circles & edges as lines.
            Text("Scene graph with \(rep.cells.count) nodes")
                .padding()
        }
    }
}
