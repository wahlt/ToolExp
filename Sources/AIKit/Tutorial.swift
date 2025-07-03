// Sources/AIKit/Tutorial.swift
//
//  Tutorial.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//
//  SwiftUI view hosting the interactive AI tutorial interface.
//

import SwiftUI

public struct TutorialView: View {
    @StateObject private var mentor = AIMentor()

    public init() {}

    public var body: some View {
        VStack {
            ScrollView {
                ForEach(mentor.history, id: \.self) { line in
                    Text(line).padding(.vertical, 2)
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .padding()

            HStack {
                TextField("Ask me...", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    Task { await mentor.send(input) }
                    input = ""
                }
            }
            .padding()
        }
        .padding()
    }

    @State private var input: String = ""
}
