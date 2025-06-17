//
//  ModuleMng+AppleAssets.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ModuleMng+AppleAssets.swift
// IntegrationKit — Enables downloading & installing Apple-hosted asset bundles.
//

import Foundation

public extension ModuleMng {
    /// Download and install an asset bundle from Apple’s CDN.
    ///
    /// - Parameter url: The HTTPS URL of the .zip asset bundle.
    /// - Throws: on network or file‐system errors.
    func installAppleAsset(from url: URL) async throws {
        // 1. Download data
        let (data, _) = try await URLSession.shared.data(from: url)
        // 2. Unzip into your Modules folder
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        //    (Use Archive framework or SSZipArchive)
        // TODO: unzip `data` into `tempDir`
        // 3. Load each plugin module from `tempDir`
        let pluginURLs = try FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
        for plugin in pluginURLs where plugin.pathExtension == "bundle" {
            try loadModule(at: plugin)
        }
    }
}
