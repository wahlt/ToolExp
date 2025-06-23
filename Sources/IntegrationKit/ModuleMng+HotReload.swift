// File: Sources/IntegrationKit/ModuleMng+HotReload.swift
//  IntegrationKit
//
//  Specification:
//  • Adds hot-reload support by watching a folder for writes.
//  • On any change, clears the ModuleMng registry so modules can be reloaded.
//
//  Discussion:
//  We use DispatchSource to monitor file-system events.  Previously this
//  closure tried to call a private `modules.removeAll()` directly, which
//  failed.  Now it invokes the public `clearModules()` API.
//
//  Rationale:
//  • Encapsulates state-reset logic in `clearModules()` in ModuleMng.
//  • Keeps the file-watching code decoupled from internal storage details.
//  • Guards concurrency by running on the main queue (matching @MainActor).
//
//  TODO:
//  • After clearing, invoke bundle scanning and descriptor registration.
//  • Debounce rapid file changes to avoid thrashing.
//  • Add unit tests simulating folder writes.
//
//  Dependencies: Foundation, Dispatch
//
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Dispatch

public extension ModuleMng {
    /// Enables hot-reloading by watching `folderURL` for any file writes.
    /// Clears existing modules on change; caller must re-scan and register.
    /// - Parameter folderURL: URL of the directory to monitor.
    func enableHotReload(at folderURL: URL) {
        let descriptor = open(folderURL.path, O_EVTONLY)
        guard descriptor >= 0 else { return }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: .write,
            queue: .main
        )

        source.setEventHandler {
            // Reset registry; next step is to rescan bundles.
            ModuleMng.shared.clearModules()
            // TODO: scan `folderURL` for updated bundles and register them
        }
        source.setCancelHandler {
            close(descriptor)
        }
        source.resume()
    }
}
