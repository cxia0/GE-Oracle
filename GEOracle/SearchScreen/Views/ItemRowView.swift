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
	let iconName: String

	var body: some View {
		HStack {
			ItemIconImageView(viewModel: ItemIconImageViewModel(iconName: iconName))
				.frame(width: 40, height: 40)
				.aspectRatio(contentMode: .fit)
			VStack(alignment: .leading) {
				Text(self.name)
					.font(.headline)
				Text(self.description)
					.font(.footnote)
					.lineLimit(1)
			}
		}
	}
}

#Preview {
	let _ = DC.shared.register(StubItemImageDataProvider(), forType: ItemImageDataProvider.self)

	ItemRowView(
		name: "Bow",
		description: "A wooden bow. A wooden bow. A wooden bow. A wooden bow.",
		iconName: "Air talisman.png"
	)
}
