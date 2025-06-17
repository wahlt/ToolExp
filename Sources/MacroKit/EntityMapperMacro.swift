//
//  EntityMapperMacro.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// EntityMapperMacro.swift
// MacroKit — Stub for SwiftSyntax macro to auto-generate
// RepStruct ↔ RepEntity mapping functions.
//
// Once implemented, DataServ save/load can be one-liners.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct EntityMapperMacro: PeerMacro {
    public static func expansion(
        of node: PeerMacroExpansionSyntax,
        providingPeersOf type: DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // TODO: Reflect on `type` to enumerate stored properties,
        // then generate `func toRepStruct() -> RepStruct` &
        // `static func fromRepStruct(_ rep: RepStruct) -> Self`.
        return []
    }
}
