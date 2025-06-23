//
//  PrefetchServ.swift
//  ServiceKit
//
//  Specification:
//  • Prefetches remote or local resources to warm caches.
//  • Reduces latency when entering new Bands or Takes.
//
//  Discussion:
//  Preloading resources (images, model data) speeds perceived responsiveness.
//
//  Rationale:
//  • Simple background downloads on utility queue.
//  • Fire-and-forget model since failures are non-critical.
//
//  Dependencies: Foundation
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation

public class PrefetchServ {
    public static let shared = PrefetchServ()
    private init() {}

    /// Fetches given URLs in parallel.
    public func prefetch(urls: [URL]) {
        let queue = DispatchQueue.global(qos: .utility)
        urls.forEach { url in
            queue.async {
                _ = try? Data(contentsOf: url)
            }
        }
    }
}
