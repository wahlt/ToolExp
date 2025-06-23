//
//  SwiftSyntax.swift
//  BuildKit
//
//  Specification:
//  • Helpers to construct or transform SwiftSyntax nodes.
//  • Emits syntax trees that can be written back to disk.
//
//  Discussion:
//  When generating code (e.g. new modules), DSL-based node builders
//  reduce errors compared to string templates.
//
//  Rationale:
//  • SwiftSyntax and SwiftSyntaxBuilder ensure AST validity.
//  • Centralized helpers promote reuse across code generation.
//
//  Dependencies: SwiftSyntax, SwiftSyntaxBuilder
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

public enum SwiftSyntaxHelper {
    /// Builds a barebones public struct with default initializer.
    public static func makeEmptyStruct(named name: String) -> StructDeclSyntax {
        return StructDeclSyntax(
            """
            public struct \(raw: name) {
                /// Default initializer.
                public init() {}
            }
            """
        )
    }
}
