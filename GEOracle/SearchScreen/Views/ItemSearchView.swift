//
//  ContentView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/01/2025.
//

import SwiftUI

struct ItemSearchView: View {
	@State var viewModel = ItemSearchViewModel()

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
		List(self.viewModel.searchResults) { item in
			ItemRowView(
				name: item.name,
				description: item.description,
				iconName: item.iconName
			)
			.background(  // Hack to remove the default styling
				NavigationLink("", value: item.name).opacity(0)
			)
			.listRowInsets(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 10))
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
	}
}

/// Mocks are in a folder that makes them development-only assets.
/// `#if DEBUG` is needed because otherwise, building for distribution fails; it seems like Xcode will still try to build the Preview.
/// Xcode most likely strips or unlinks the code from the Release artifact AFTER the build.
#if DEBUG
#Preview {
	let _ = DC.shared.register(
		StubItemDataProvider(),
		forType: ItemDataProvider.self
	)

	let _ = DC.shared.register(
		StubItemPricesProvider(),
		forType: ItemPricesProvider.self
	)

	let _ = DC.shared.register(
		StubItemImageDataProvider(delay: .seconds(1)),
		forType: ItemImageDataProvider.self
	)

	NavigationStack {
		ItemSearchView()
	}
}
#endif
