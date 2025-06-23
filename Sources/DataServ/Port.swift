// File: DataServ/Port.swift
//
//  Port.swift
//  DataServ
//
//  Specification:
//  • Legacy publisher/subscriber conduit, now aliased to RepKit.Port.
//  • Deprecated in favor of a single `Port<T>` in RepKit.
//
//  Discussion:
//  Consolidating `Port<T>` implementations avoids confusion.
//
//  Rationale:
//  • DataServ events should reuse the same reactive type as core RepKit.
//  TODO:
//    – [ ] Remove this alias once all uses point to RepKit.Port.
//
//  Dependencies: RepKit
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import RepKit

@available(*, deprecated, message: "Use RepKit.Port<T> instead")
public typealias Port<T> = RepKit.Port<T>
