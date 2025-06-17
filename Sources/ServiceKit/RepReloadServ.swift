//
//  RepReloadServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// RepReloadServ.swift
// ServiceKit — Watches a folder for `.rep` files and reloads at runtime.
//
// (Reprinted here to ensure you have the latest edition.)
//

import Foundation

public extension Notification.Name {
    static let didReloadRep = Notification.Name("didReloadRep")
}

public final class RepReloadServ {
    public static let shared = RepReloadServ()
    private var watcher: DispatchSourceFileSystemObject?

    private init() {}

    /// Start watching the given directory for `.rep` files.
    public func watch(directory url: URL) throws {
        let fd = open(url.path, O_EVTONLY)
        guard fd >= 0 else { throw NSError(domain: "RepReloadServ", code: 1) }
        watcher = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: .write,
            queue: .global()
        )
        watcher?.setEventHandler { [weak self] in
            self?.reloadAll(from: url)
        }
        watcher?.resume()
    }

    /// Load all `.rep` files in the directory and post notifications.
    private func reloadAll(from url: URL) {
        let files = (try? FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil
        )) ?? []

        for file in files where file.pathExtension == "rep" {
            // TODO: parse into RepStruct then:
            // NotificationCenter.default.post(name: .didReloadRep, object: rep)
        }
    }
}
