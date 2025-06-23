//
//  DataServ.swift
//  DataServ
//
//  Specification:
//  • Generic JSON-based persistence for Codable types.
//  • Stores arrays under `<storageKey>.json` in Application Support.
//  • Thread-safe read/write via atomic file operations.
//
//  Discussion:
//  Local persistence must survive app launches and iCloud sync.
//  Saving entire arrays trades off simplicity for rewrite overhead.
//
//  Rationale:
//  • Codable + JSONEncoder/Decoder provides type safety.
//  • Application Support directory chosen for user-safe storage.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public protocol Persistable: Codable {
    /// Filename (without extension) for storage.
    static var storageKey: String { get }
}

public class DataServ {
    public static let shared = DataServ()
    private let baseURL: URL

    private init() {
        let fm = FileManager.default
        let support = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        baseURL = support.appendingPathComponent("DataServ", isDirectory: true)
        try? fm.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }

    /// Loads all saved items of type T.
    public func loadAll<T: Persistable>(_ type: T.Type) throws -> [T] {
        let url = baseURL.appendingPathComponent("\(T.storageKey).json")
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([T].self, from: data)
    }

    /// Saves an array of items, overwriting existing file.
    public func saveAll<T: Persistable>(_ items: [T], as type: T.Type) throws {
        let data = try JSONEncoder().encode(items)
        let url = baseURL.appendingPathComponent("\(T.storageKey).json")
        try data.write(to: url, options: [.atomic])
    }
}
