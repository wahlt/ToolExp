//
//  ResourceServ.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// ResourceServ.swift
// ServiceKit — Central manager for loading & caching external resources (images, models).
//

import Foundation
import UIKit

public actor ResourceServ {
    private let cache = NSCache<NSURL, NSData>()

    /// Load resource data from a URL, with in-memory caching.
    public func load(url: URL) async throws -> Data {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached as Data
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        cache.setObject(data as NSData, forKey: url as NSURL)
        return data
    }
}
