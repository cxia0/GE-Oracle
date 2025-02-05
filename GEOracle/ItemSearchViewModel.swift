//
//  ItemSearchViewModel.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 04/02/2025.
//

import Foundation

@Observable
final class ItemSearchViewModel {

	private let itemPricesProvider: ItemPricesProvider
	private let itemDataProvider: ItemDataProvider

	private var items = [Item]()
	private(set) var itemSearchResults = [Item]()

	private let searchDelay: Duration
	private var searchTask: Task<(), Error>?

	var searchText: String = "" {
		didSet {
			let trimmedText = self.searchText.trimmingCharacters(in: .whitespaces)
			guard trimmedText.isEmpty == false else {
				self.itemSearchResults = []
				return
			}

			self.searchTask?.cancel()
			self.searchTask = Task { @MainActor in
				try await Task.sleep(for: self.searchDelay)
				self.updateItemSearchResults(with: trimmedText)
			}
		}
	}

	init(
		itemPricesProvider: some ItemPricesProvider = RuneScapeWikiAPIClient(),
		itemDataProvider: some ItemDataProvider = RuneScapeWikiAPIClient(),
		searchDelay: Duration = .milliseconds(300)
	) {
		self.itemPricesProvider = itemPricesProvider
		self.itemDataProvider = itemDataProvider
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

	func updateItemSearchResults(with text: String) {
		// TODO: Can this be made for efficient?
		self.itemSearchResults = self.items.filter { item in
			item.name.localizedCaseInsensitiveContains(text)
		}
	}
}
