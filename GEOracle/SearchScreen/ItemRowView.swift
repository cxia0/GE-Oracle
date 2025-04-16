//
//  ItemRowView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 02/02/2025.
//

import SwiftUI

struct ItemRowView: View {
	let name: String
	let description: String
	let image: Image
	var body: some View {
		HStack {
			self.image
				.frame(width: 40, height: 40)
				.aspectRatio(contentMode: .fit)
			VStack(alignment: .leading) {
				Text(self.name)
					.font(.headline)
				Text(self.description)
					.font(.footnote)
			}
		}
	}
}

#Preview {
	ItemRowView(
		name: "Bow",
		description: "A wooden bow.",
		image: Image(systemName: "gamecontroller.fill")
	)
}
