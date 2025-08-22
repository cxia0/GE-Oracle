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
	@ObservationIgnored private let itemTradingDataProvider: ItemTradingDataProvider
	@ObservationIgnored private let itemDataProvider: ItemDataProvider
	@ObservationIgnored private let itemImageDataProvider: ItemImageDataProvider

	// Public
	private(set) var searchResults = [Item]()
	private(set) var itemImages = [Int: Image]()
	@ObservationIgnored var searchText: String {
		didSet { self.searchTextDidChange() }
	}

	// Private
	@ObservationIgnored private var searchableItems = [(Item, String)]()
	@ObservationIgnored private let searchDelay: Duration
	@ObservationIgnored private var searchTask: Task<(), Error>?

	init(
		searchDelay: Duration = .milliseconds(300),
		initialSearch: String = ""
	) {
		self.itemTradingDataProvider = DC.shared.resolve(forType: ItemTradingDataProvider.self)!
		self.itemDataProvider = DC.shared.resolve(forType: ItemDataProvider.self)!
		self.itemImageDataProvider = DC.shared.resolve(forType: ItemImageDataProvider.self)!

		self.searchDelay = searchDelay

		self.searchText = initialSearch
		self.searchTextDidChange()
	}

	func loadItems() async {
		do {
			let items = try await self.itemDataProvider.fetchItems()
			self.searchableItems = items.map { item in

				let normalizedName = item.name.folding(
					options: [
						.caseInsensitive,
						.widthInsensitive,
						.diacriticInsensitive,
					],
					locale: nil
				)

				return (item, normalizedName)
			}
		} catch {
			// TODO: Display error
			print(error)
		}
	}
}

extension ItemSearchViewModel {

	private func searchTextDidChange() {

		self.searchTask?.cancel()

		let trimmedText = self.searchText.trimmingCharacters(in: .whitespaces)
		guard trimmedText.isEmpty == false else {
			self.searchResults = []
			return
		}

		self.searchTask = Task.detached(priority: .userInitiated) {

			try await Task.sleep(for: self.searchDelay)

			try Task.checkCancellation()

			let itemSearchResults = try await self.search(
				for: self.searchText,
				in: self.searchableItems
			)

			await MainActor.run {
				self.searchResults = itemSearchResults
			}
		}
	}

	nonisolated private func search(
		for query: String,
		in items: [(Item, String)]
	) throws -> [Item] {

		let normalizedSearch = query.folding(
			options: [
				.caseInsensitive,
				.widthInsensitive,
				.diacriticInsensitive,
			],
			locale: nil
		)

		var results = [Item]()

		for (item, normalizedName) in items {
			try Task.checkCancellation()
			if normalizedName.contains(normalizedSearch) {
				results.append(item)
			}
		}

		return results
	}
}
