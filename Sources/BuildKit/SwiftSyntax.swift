//
//  SwiftSyntax.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// SwiftSyntax.swift
// BuildKit — Scans source files for custom macros and expands them.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

/// Tooling wrapper for SwiftSyntax macro expansion.
public struct SwiftSyntaxTool {
    /// Process all `.swift` files in the directory, expanding macros.
    public func processMacros(in sourceDir: URL) throws {
        let fm = FileManager.default
        let files = try fm.contentsOfDirectory(at: sourceDir, includingPropertiesForKeys: nil)
        for file in files where file.pathExtension == "swift" {
            let tree = try SyntaxParser.parse(file)
            // TODO: Walk tree, find macro invocations, expand via MacroKit
            // and overwrite file with generated code.
        }
    }
}
