//
//  ItemIconImageView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 30/04/2025.
//

import SwiftUI

@Observable
@MainActor
final class ItemIconImageViewModel {

	enum State {
		case idle
		case loading
		case loaded(image: Image)
		case failedToLoad
	}

	private(set) var state = State.idle
	@ObservationIgnored private let iconName: String
	@ObservationIgnored private let imageDataProvider: ItemImageDataProvider

	init(
		iconName: String,
	) {
		self.iconName = iconName
		self.imageDataProvider = DC.shared.resolve(forType: ItemImageDataProvider.self)!
	}

	func loadImage() async {
		do {
			self.state = .loading

			guard let imageData = try? await self.imageDataProvider.fetchIconImageData(iconName),
                  let uiImage = UIImage(data: imageData)
			else {
				self.state = .failedToLoad
				return
			}

			try Task.checkCancellation()

			self.state = .loaded(image: Image(uiImage: uiImage))
		} catch {}
	}
}

struct ItemIconImageView: View {
	@State var viewModel: ItemIconImageViewModel

	init(iconName: String) {
		self.viewModel = ItemIconImageViewModel(iconName: iconName)
	}

	var body: some View {
		switch self.viewModel.state {
		case .idle, .loading:
			RoundedRectangle(cornerRadius: 5)
				.fill(Color(.systemGray5))
				.task {
					await self.viewModel.loadImage()
				}
		case .loaded(let image):
			image
		case .failedToLoad:
			Image(systemName: "photo").opacity(0.5)
		}
	}
}

#Preview {
	let _ = DC.shared.register(
		StubItemImageDataProvider(),
		forType: ItemImageDataProvider.self
	)

	ItemIconImageView(
		iconName: "Air_orb",
	)
	.frame(width: 50, height: 50)

}

#Preview {
	let _ = DC.shared.register(
		StubItemImageDataProvider(),
		forType: ItemImageDataProvider.self
	)

	ItemIconImageView(
		iconName: "Air_orb_detail",
	)
	.frame(width: 50, height: 50)
}
