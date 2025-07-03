//
//  DominionManager.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  DominionManager.swift
//  UXKit
//
//  1. Purpose
//     Manages the active “dominion” (root RepStruct) and selection.
// 2. Dependencies
//     RepKit, Combine
// 3. Overview
//     Publishes changes to the current RepStruct and selected cell IDs.
// 4. Usage
//     Inject into views to drive data-binding and editing.
// 5. Notes
//     Supports undo/redo via `RepUpdate`.

import Foundation
import RepKit
import Combine

/// Holds the current project rep (“dominion”) and selection state.
public final class DominionManager: ObservableObject {
    @Published public private(set) var rep: RepStruct
    @Published public var selectedCellIDs: Set<UUID> = []

    private var history: [RepStruct] = []
    private var future: [RepStruct] = []

    public init(root: RepStruct = RepStruct()) {
        self.rep = root
    }

    /// Apply an update and push to undo history.
    public func apply(_ update: RepUpdate) {
        history.append(rep)
        future.removeAll()
        try? rep.apply(update)
        objectWillChange.send()
    }

    /// Undo last change.
    public func undo() {
        guard let prev = history.popLast() else { return }
        future.append(rep)
        rep = prev
        objectWillChange.send()
    }

    /// Redo last undone change.
    public func redo() {
        guard let next = future.popLast() else { return }
        history.append(rep)
        rep = next
        objectWillChange.send()
    }
}
