//
//  ToolAppCoordinator.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/22/25.
//

//
//  ToolAppCoordinator.swift
//  ToolApp
//
//  Specification:
//  • Manages SuperStage transitions and global app state.
//
//  Discussion:
//  Coordinates which View/Takes are active per SuperStage.
//
//  Rationale:
//  • Keeps stage logic out of views.
//  Dependencies: Foundation, StageKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Combine

public class ToolAppCoordinator: ObservableObject {
    @Published public private(set) var currentStage: String = "ToolExp"

    public func loadStage(_ id: String?) {
        guard let id = id else { return }
        currentStage = id
    }
}
