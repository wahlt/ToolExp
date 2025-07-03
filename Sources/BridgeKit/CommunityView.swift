//
//  CommunityView.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

// Sources/BridgeKit/CommunityView.swift
//
//  CommunityView.swift
//  BridgeKit
//
//  Created by Thomas Wahl on 2025-06-xx.
//  © 2025 Cognautics. All rights reserved.
//
//  SwiftUI list presenting posts from CommunityService.
//

import SwiftUI

public struct CommunityView: View {
    @State private var posts: [CommunityPost] = []

    public init() {}

    public var body: some View {
        List(posts) { post in
            VStack(alignment: .leading, spacing: 4) {
                Text(post.author)
                    .font(.headline)
                Text(post.content)
                    .font(.body)
                Text(post.timestamp, style: .date)
                    .font(.caption)
            }
            .padding(.vertical, 6)
        }
        .onAppear(perform: loadPosts)
    }

    /// Triggers fetch and updates `posts` on the main thread.
    private func loadPosts() {
        CommunityService().fetchPosts { fetched in
            DispatchQueue.main.async {
                self.posts = fetched
            }
        }
    }
}
