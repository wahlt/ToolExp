//
//  MagicKit.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// MagicKit.swift
// StageKit — Random/AI-driven “magic” mutations & rollbacks.
//

import Foundation
import RepKit

public struct MagicKit {
    private static var history: [RepStruct] = []

    /// Apply a random magic mutation to the Rep.
    public static func randomMutation(on rep: RepStruct) -> RepStruct {
        history.append(rep)
        // Example mutation: swap two cells’ data
        let ids = Array(rep.cells.keys)
        guard ids.count >= 2 else { return rep }
        var newRep = rep
        let a = ids.randomElement()!, b = ids.randomElement()!
        let da = rep.cells[a]!.data, db = rep.cells[b]!.data
        newRep = (try? newRep.updatingData(of: a, to: db)) ?? newRep
        newRep = (try? newRep.updatingData(of: b, to: da)) ?? newRep
        return newRep
    }

    /// Revert the last mutation.
    public static func revertLast(on rep: RepStruct) -> RepStruct {
        return history.popLast() ?? rep
    }
}
