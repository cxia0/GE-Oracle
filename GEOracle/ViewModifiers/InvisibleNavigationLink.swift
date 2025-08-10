//
//  InvisibleNavigationLink.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 26/07/2025.
//

import SwiftUI

extension View {
	func invisibleNavigationLink(value: some Hashable) -> some View {
		self.background(
			NavigationLink("", value: value)
                .opacity(0)
		)
	}
}
