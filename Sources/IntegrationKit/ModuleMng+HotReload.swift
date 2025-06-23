//
//  ModuleMng+HotReload.swift
//  IntegrationKit
//
//  Specification:
//  • Watches folders for code/resource changes and reloads modules.
//  • Uses DispatchSourceFileSystemObject for file-watching.
//
//  Discussion:
//  During development, hot-reload speeds iteration for ToolExp.
//
//  Rationale:
//  • Improves developer velocity.
//  Dependencies: Dispatch, Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public extension ModuleMng {
    /// Starts watching a folder for changes.
    func watch(folderURL: URL) {
        let fd = open(folderURL.path, O_EVTONLY)
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: .write,
            queue: DispatchQueue.global()
        )
        source.setEventHandler { [weak self] in
            self?.modules.removeAll()
            // TODO: Scan folderURL for updated bundles
        }
        source.setCancelHandler { close(fd) }
        source.resume()
    }
}
