//
//  FourPaneLayout.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// FourPaneLayout.swift
// UXKit — Custom 2×2 grid layout (reprint for completeness).
//

import SwiftUI

public struct FourPaneLayout: Layout {
    public init() {}

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let w = proposal.width  ?? 800
        let h = proposal.height ?? 600
        return CGSize(width: w, height: h)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let hw = bounds.width / 2
        let hh = bounds.height / 2
        let frames = [
            CGRect(x: bounds.minX,           y: bounds.minY,           width: hw, height: hh),
            CGRect(x: bounds.minX + hw,      y: bounds.minY,           width: hw, height: hh),
            CGRect(x: bounds.minX,           y: bounds.minY + hh,      width: hw, height: hh),
            CGRect(x: bounds.minX + hw,      y: bounds.minY + hh,      width: hw, height: hh),
        ]
        for (i, subview) in subviews.enumerated() where i < 4 {
            subview.place(at: frames[i].origin, proposal: ProposedViewSize(frames[i].size))
        }
    }
}
