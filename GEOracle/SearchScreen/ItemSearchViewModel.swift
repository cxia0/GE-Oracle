//
//  ItemSearchViewModel.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 04/02/2025.
//

import Observation
import SwiftUI

@Observable
@MainActor
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

	init(searchDelay: Duration = .milliseconds(300)) {
		self.itemPricesProvider = DC.shared.resolve(forType: ItemPricesProvider.self)!
		self.itemDataProvider = DC.shared.resolve(forType: ItemDataProvider.self)!
		self.itemImageDataProvider = DC.shared.resolve(forType: ItemImageDataProvider.self)!

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
