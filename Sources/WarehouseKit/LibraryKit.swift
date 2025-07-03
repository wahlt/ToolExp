//
//  LibraryKit.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  LibraryKit.swift
//  WarehouseKit
//
//  1. Purpose
//     Manages shared libraries or templates for rep reuse.
// 2. Dependencies
//     Foundation, RepKit
// 3. Overview
//     Loads library `.rep` bundles, exposes named templates.
// 4. Usage
//     `LibraryKit.shared.loadLibrary("StandardShapes")`
// 5. Notes
//     Library bundles are folders with `.rep` files.

import Foundation
import RepKit

public final class LibraryKit {
    public static let shared = LibraryKit()
    private init() {}

    private var libraries: [String: [RepStruct]] = [:]

    /// Loads a library by name from app bundle.
    public func loadLibrary(_ name: String) throws -> [RepStruct] {
        if let reps = libraries[name] { return reps }
        guard let url = Bundle.main.url(forResource: name, withExtension: nil, subdirectory: "Libraries") else {
            throw NSError(domain:"LibraryKit", code:1, userInfo:nil)
        }
        let fm = FileManager.default
        let files = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        let reps = try files.compactMap { file -> RepStruct? in
            guard file.pathExtension == "rep",
                  let data = try? Data(contentsOf: file) else { return nil }
            return try RepSerializer().deserialize(data: data)
        }
        libraries[name] = reps
        return reps
    }
}
