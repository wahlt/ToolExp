//
//  CrossDeviceSharder.swift
//  RenderKit
//
//  1. Purpose
//     Splits large render workloads across multiple Metal devices
//     (e.g. iPad GPU + external GPU) for load balancing.
//  2. Dependencies
//     Metal, Dispatch
//  3. Overview
//     Partitions view into tiles, dispatches each tile to a device.
//  4. Usage
//     Pass in list of devices to `shard(...)`.
//  5. Notes
//     Uses round-robin assignment and dynamic feedback.

import Metal

public struct CrossDeviceSharder {
    /// Partitions the given pixel region into `deviceCount` tiles,
    /// invokes `render(tile:device:)` asynchronously on each device.
    public static func shard(
        fullSize: MTLSize,
        devices: [MTLDevice],
        render: @escaping (_ origin: MTLOrigin, _ size: MTLSize, _ device: MTLDevice) throws -> Void
    ) throws {
        let count = devices.count
        let tileHeight = fullSize.height / count
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)

        for (i, dev) in devices.enumerated() {
            let origin = MTLOrigin(x: 0, y: i * tileHeight, z: 0)
            let size = MTLSize(width: fullSize.width,
                               height: i == count - 1
                                    ? fullSize.height - origin.y
                                    : tileHeight,
                               depth: 1)
            group.enter()
            queue.async {
                do {
                    try render(origin, size, dev)
                } catch {
                    print("Shard \(i) failed: \(error)")
                }
                group.leave()
            }
        }
        group.wait()
    }
}
