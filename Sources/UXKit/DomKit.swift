//
//  DomKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  DomKit.swift
//  UXKit
//
//  1. Purpose
//     UI toolkit for constructing and editing RepStructs in “DOM” style.
// 2. Dependencies
//     SwiftUI, RepKit
// 3. Overview
//     Provides views to inspect cells, ports, traits, and links.
// 4. Usage
//     `DomKit.view(for: dominionManager)`
// 5. Notes
//     Editable in-place; emits `RepUpdate`s back to `DominionManager`.

import SwiftUI
import RepKit

public enum DomKit {
    /// Returns the root editing view for a given `DominionManager`.
    public static func view(for dominion: DominionManager) -> some View {
        DomRootView(dominion: dominion)
    }

    /// Main container showing cell list and details.
    private struct DomRootView: View {
        @ObservedObject var dominion: DominionManager

        var body: some View {
            HSplitView {
                // Left: list of cells
                List(dominion.rep.cells) { cell in
                    Text(cell.name)
                        .onTapGesture {
                            dominion.selectedCellIDs = [cell.id]
                        }
                }
                .frame(minWidth: 200)

                // Right: detail editor for selected cell
                if let id = dominion.selectedCellIDs.first,
                   let cell = dominion.rep.cell(withID: id) {
                    CellDetailView(cell: cell, dominion: dominion)
                } else {
                    Text("Select a cell to edit")
                        .italic()
                }
            }
        }
    }

    /// Detailed view for a single cell’s ports and traits.
    private struct CellDetailView: View {
        let cell: Cell
        @ObservedObject var dominion: DominionManager

        @State private var newPortName: String = ""

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cell: \(cell.name)").font(.headline)

                // Ports
                GroupBox(label: Text("Ports")) {
                    VStack {
                        ForEach(cell.ports) { port in
                            HStack {
                                Text(port.name)
                                Spacer()
                                Button("–") {
                                    let upd = RepUpdate.removePort(cellID: cell.id, portName: port.name)
                                    dominion.apply(upd)
                                }
                            }
                        }
                        HStack {
                            TextField("New port", text: $newPortName)
                            Button("+") {
                                let upd = RepUpdate.addPort(cellID: cell.id, portName: newPortName, defaultValue: .float(0))
                                dominion.apply(upd)
                                newPortName = ""
                            }
                        }
                    }.padding()
                }

                // Traits
                GroupBox(label: Text("Traits")) {
                    VStack {
                        ForEach(cell.traits, id:\.self) { trait in
                            Text(String(describing: trait))
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}
