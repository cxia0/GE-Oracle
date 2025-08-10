//
//  RoundedBorder.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 10/08/2025.
//

import SwiftUI

// Why create ViewModifiers instead of simply using an extension?
// The type signature is cleaner, allowing for easier debugging.
// https://stackoverflow.com/a/73815651

struct RoundedBorder<S: ShapeStyle>: ViewModifier {

	let style: S
	let cornerRadius: CGFloat
	let lineWidth: CGFloat

	init(style: S, cornerRadius: CGFloat, lineWidth: CGFloat) {
		self.style = style
		self.cornerRadius = cornerRadius
		self.lineWidth = lineWidth
	}

	func body(content: Content) -> some View {
		content
			.overlay {
				RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(style, lineWidth: lineWidth)
			}
	}
}

extension View {
	func roundedBorder(
        style: some ShapeStyle,
        cornerRadius: CGFloat,
        lineWidth: CGFloat
	) -> some View {
		self.modifier(
			RoundedBorder(
				style: style,
				cornerRadius: cornerRadius,
				lineWidth: lineWidth
			)
		)
	}
}
