//
//  CommunityService.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/CommunityService.swift
//
//  CommunityService.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  Fetches and decodes community‐shared code posts.
//

import Foundation

/// Model of a public community post.
public struct CommunityPost: Decodable, Identifiable {
    public let id: String              // Unique post ID
    public let author: String          // Display name of the author
    public let content: String         // Markdown or plain text body
    public let timestamp: Date         // When it was published
}

/// Adaptor for retrieving posts from a remote community API.
public final class CommunityService: BridgeAdaptor {
    public static let name = "CommunityService"
    private let session = URLSession.shared

    public init() {}

    /// Fetches the latest posts asynchronously.
    /// - Parameter completion: called on background thread with result.
    public func fetchPosts(
        completion: @escaping ([CommunityPost]) -> Void
    ) {
        guard let url = URL(string: "https://api.example.com/posts") else {
            completion([])
            return
        }
        session.dataTask(with: url) { data, _, error in
            guard error == nil,
                  let data = data,
                  let posts = try? JSONDecoder().decode(
                      [CommunityPost].self,
                      from: data
                  )
            else {
                completion([])
                return
            }
            completion(posts)
        }.resume()
    }
}
