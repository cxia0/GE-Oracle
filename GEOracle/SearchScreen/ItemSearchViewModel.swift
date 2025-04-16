//
//  ItemSearchViewModel.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 04/02/2025.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class ItemSearchViewModel {

	// Dependencies
	@ObservationIgnored private let itemPricesProvider: ItemPricesProvider
	@ObservationIgnored private let itemDataProvider: ItemDataProvider
	@ObservationIgnored private let itemImageDataProvider: ItemImageDataProvider

	@ObservationIgnored private var items = [Item]()
	private(set) var itemSearchResults = [Item]()
	private(set) var itemImages = [Int: Image]()

	@ObservationIgnored private let searchDelay: Duration
	@ObservationIgnored private var searchTask: Task<(), Error>?

	@ObservationIgnored var searchText: String = "" {
		didSet { searchTextDidChange() }
	}

	init(
		itemPricesProvider: some ItemPricesProvider = RuneScapeWikiAPIClient(),
		itemDataProvider: some ItemDataProvider = RuneScapeWikiAPIClient(),
		itemImageDataProvider: some ItemImageDataProvider = RuneScapeWikiAPIClient(),
		searchDelay: Duration = .milliseconds(300)
	) {
		self.itemPricesProvider = itemPricesProvider
		self.itemDataProvider = itemDataProvider
		self.itemImageDataProvider = itemImageDataProvider
		self.searchDelay = searchDelay
	}

	func loadItems() async {
		do {
			self.items = try await self.itemDataProvider.fetchItems()
		} catch {
			// TODO: Display error
			print(error)
		}
	}
}

extension ItemSearchViewModel {

	private func searchTextDidChange() {

		let trimmedText = self.searchText.trimmingCharacters(in: .whitespaces)

		self.searchTask?.cancel()

		guard trimmedText.isEmpty == false else {
			self.itemSearchResults = []
			return
		}

		self.searchTask = Task {

			try await Task.sleep(for: self.searchDelay)

			try Task.checkCancellation()

			var itemSearchResults = [Item]()

			await MainActor.run {
				itemSearchResults = self.searchForItems(with: self.searchText, self.items)
				self.itemSearchResults = itemSearchResults
			}

			let imageProvider = self.itemImageDataProvider

			for item in itemSearchResults {

				try Task.checkCancellation()

				let imageData = try await imageProvider.fetchIconImageData(item.iconName)
				guard let uiImage = UIImage(data: imageData) else { return }
				Task { @MainActor in
					self.itemImages[item.id] = Image(uiImage: uiImage)
				}
			}
		}
	}

	private func searchForItems(
		with itemName: String,
		_ items: [Item]
	) -> [Item] {
		// TODO: Can this be made more efficient?
		return items.filter { item in
			item.name.localizedCaseInsensitiveContains(itemName)
		}
	}
}
