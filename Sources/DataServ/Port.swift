//
//  Port.swift
//  DataServ
//
//  Created by ToolExp Recovery on 2025-06-23.
//  © 2025 Cognautics. All rights reserved.
//
//  Description:
//  Models a connection endpoint between Rep entities.
//

import Foundation

public struct Port {
    public let id: String
    public let fromCellID: String
    public let toCellID: String

    public init(id: String, from: String, to: String) {
        self.id = id
        self.fromCellID = from
        self.toCellID = to
    }
}
