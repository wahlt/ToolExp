//
//  ModuleMng+HotReload.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ModuleMng+HotReload.swift
// IntegrationKit — Watches the Modules directory and hot‐reloads on change.
//

import Foundation

public extension ModuleMng {
    /// Begins watching your Modules folder for additions/removals.
    ///
    /// - Parameter modulesURL: local URL of your Modules directory.
    /// - Throws: if the directory cannot be monitored.
    func enableHotReload(in modulesURL: URL) throws {
        // 1. Open a file descriptor for FSEvents
        let fd = open(modulesURL.path, O_EVTONLY)
        guard fd >= 0 else { throw NSError(domain: "ModuleMng", code: 2) }
        // 2. Create a DispatchSourceFileSystemObject
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: .write,
            queue: .main
        )
        source.setEventHandler { [weak self] in
            // 3. On any change, rescan and reload
            Task {
                let contents = try? FileManager.default.contentsOfDirectory(at: modulesURL, includingPropertiesForKeys: nil)
                for url in contents ?? [] where url.pathExtension == "bundle" {
                    try? self?.loadModule(at: url)
                }
            }
        }
        source.resume()
    }
}
