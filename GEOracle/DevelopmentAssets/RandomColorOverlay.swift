//
//  RandomColorOverlay.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 20/07/2025.
//

import SwiftUI

struct RandomColorOverlayModifier: ViewModifier {
    private let color: Color = Color(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1)
    )

    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .stroke(color, lineWidth: 2)
                    .background(color)
                    .opacity(0.2)
            }
    }
}

extension View {
    func randomColorOverlay() -> some View {
        self.modifier(RandomColorOverlayModifier())
    }
}
