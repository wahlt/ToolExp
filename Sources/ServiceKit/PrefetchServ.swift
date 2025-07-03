//
//  RepReloadServ.swift
//  ServiceKit
//
//  1. Purpose
//     Watches a directory for RepStruct JSON changes and reloads them.
// 2. Dependencies
//     Foundation, Dispatch, RepKit
// 3. Overview
//     Uses DispatchSource to monitor file system events,
//     deserializes changed RepStruct and posts `.repDidReload`.
// 4. Usage
//     RepReloadServ.shared.start(watching: someFolderURL)
// 5. Notes
//     Only supports JSON files with `.rep` extension.

import Foundation
import Dispatch
import RepKit

public final class RepReloadServ {
    public static let shared = RepReloadServ()
    private init() {}

    private var source: DispatchSourceFileSystemObject?

    /// Begins watching a directory for `.rep` file changes.
    public func start(watching folder: URL) throws {
        stop()
        let fd = open(folder.path, O_EVTONLY)
        guard fd >= 0 else { throw NSError(domain: "RepReload", code: 1) }
        let src = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: .write,
            queue: .global()
        )
        src.setEventHandler { [weak self] in
            self?.reloadAll(in: folder)
        }
        src.setCancelHandler { close(fd) }
        src.resume()
        source = src
    }

    /// Stops watching.
    public func stop() {
        source?.cancel()
        source = nil
    }

    /// Reloads all `.rep` files and posts notifications.
    private func reloadAll(in folder: URL) {
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) else { return }
        for file in files where file.pathExtension == "rep" {
            if let data = try? Data(contentsOf: file),
               let rep  = try? RepSerializer().deserialize(data: data) {
                NotificationCenter.default.post(
                    name: .repDidReload,
                    object: rep
                )
            }
        }
    }
}

public extension Notification.Name {
    static let repDidReload = Notification.Name("RepReloadServDidReload")
}
