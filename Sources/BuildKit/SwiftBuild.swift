//
//  SwiftBuild.swift
//  BuildKit
//
//  Specification:
//  • Programmatic access to SwiftPM manifests and dependency graphs.
//  • Parses `Package.swift` via SwiftSyntax for introspection.
//
//  Discussion:
//  Tool can expose module dependencies dynamically by
//  parsing the manifest. This aids auto-completion and scaffolding.
//
//  Rationale:
//  • SwiftSyntax-based parsing avoids brittle string hacks.
//  • Exposing manifest AST enables future plugin systems.
//
//  Dependencies: SwiftSyntax, SwiftSyntaxParser
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

public class SwiftBuild {
    /// Reads the raw text of `Package.swift`.
    public func manifest(at packagePath: String) throws -> String {
        let url = URL(fileURLWithPath: packagePath).appendingPathComponent("Package.swift")
        return try String(contentsOf: url)
    }

    /// Parses the manifest into a `SourceFileSyntax` tree.
    public func parseManifest(at packagePath: String) throws -> SourceFileSyntax {
        let text = try manifest(at: packagePath)
        let tree = try SyntaxParser.parse(source: text)
        guard let file = tree as? SourceFileSyntax else {
            throw NSError(domain: "SwiftBuild", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to parse manifest"])
        }
        return file
    }
}
