//
//  ContentView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/01/2025.
//

import SwiftUI

@Observable
final class ItemSearchViewModel {

	private let itemPricesProvider: ItemPricesProvider
	private let itemDataProvider: ItemDataProvider

	private var items = [Item]()
	private(set) var itemSearchResults = [Item]()

	var searchText: String = "" {
		didSet {
			let trimmedText = self.searchText.trimmingCharacters(in: .whitespaces)
			guard trimmedText.isEmpty == false else {
				self.itemSearchResults = []
				return
			}

			self.updateItemSearchResults(with: trimmedText)
		}
	}

	init(
		itemPricesProvider: some ItemPricesProvider = RuneScapeWikiAPIClient(),
		itemDataProvider: some ItemDataProvider = RuneScapeWikiAPIClient()
	) {
		self.itemPricesProvider = itemPricesProvider
		self.itemDataProvider = itemDataProvider
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

struct ItemSearchView: View {
	@Bindable var viewModel: ItemSearchViewModel
	var body: some View {
		VStack {
			SearchBarView(searchText: self.$viewModel.searchText)
			self.searchResultsView
		}
		.padding()
		.task {
			await self.viewModel.loadItems()
		}
	}

	var searchResultsView: some View {
		List {
			ForEach(self.viewModel.itemSearchResults) { item in
				ItemRowView(
					name: item.name,
					description: item.description,
					image: Image(systemName: "gamecontroller.fill")
				)
				.listRowInsets(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 10))
				.listRowSeparator(.hidden)
			}
		}
		.listStyle(.plain)
	}
}

/// Mocks are in a folder that makes them development-only assets.
/// `#if DEBUG` is needed because otherwise, building for distribution fails; it seems like Xcode will still try to build the Preview.
/// Xcode most likely strips or unlinks the code from the Release artifact AFTER the build.
#if DEBUG
#Preview {
	@Previewable @State var viewModel = ItemSearchViewModel(
		itemPricesProvider: MockItemPricesProvider(),
		itemDataProvider: MockItemDataProvider()
	)
	ItemSearchView(viewModel: viewModel)
}
#endif
