//
//  ItemSearchViewModelTests.swift
//  GEOracleTests
//
//  Created by Chunfeng Xia on 31/01/2025.
//

import Testing
@testable import GEOracle

struct ItemSearchViewModelTests {
	
	let itemPricesProvider = MockItemPricesProvider()
	let itemDataProvider = MockItemDataProvider()
	
	let viewModel: ItemSearchViewModel
	
	init() {
		
		self.itemDataProvider.fetchItemsClosure = {
			[
				Item(id: 0, name: "Ring", description: "", isMembersOnly: false, value: 10),
				Item(id: 1, name: "Draconic sword", description: "", isMembersOnly: true, value: 10),
				Item(id: 2, name: "Elven sword", description: "", isMembersOnly: true, value: 10),
				Item(id: 3, name: "Sword of the Undead", description: "", isMembersOnly: true, value: 10),
				Item(id: 4, name: "Shield", description: "", isMembersOnly: true, value: 10),
			]
		}

		self.viewModel = ItemSearchViewModel(
			itemPricesProvider: self.itemPricesProvider,
			itemDataProvider: self.itemDataProvider
		)
	}
	
	@Test func searchReturnsItemsMatchingSearchedTextCaseInsensitively() async throws {

		await self.viewModel.loadItems()
		
		
		#expect(self.viewModel.itemSearchResults.count == 0)
		
		let swordString = "sword"
		
		// Search should be case insensitive
		self.viewModel.searchText = "swo"
		#expect(self.viewModel.itemSearchResults.count == 3)
		#expect(self.viewModel.itemSearchResults[0].name.localizedCaseInsensitiveContains(swordString))
		#expect(self.viewModel.itemSearchResults[1].name.localizedCaseInsensitiveContains(swordString))
		#expect(self.viewModel.itemSearchResults[2].name.localizedCaseInsensitiveContains(swordString))
		
		self.viewModel.searchText = "Swo"
		#expect(self.viewModel.itemSearchResults.count == 3)
		#expect(self.viewModel.itemSearchResults[0].name.localizedCaseInsensitiveContains(swordString))
		#expect(self.viewModel.itemSearchResults[1].name.localizedCaseInsensitiveContains(swordString))
		#expect(self.viewModel.itemSearchResults[2].name.localizedCaseInsensitiveContains(swordString))
    }
	
	@Test func searchReturnsNothingWhenSearchingForNonexistentItem() async throws {
		await self.viewModel.loadItems()
		
		self.viewModel.searchText = "abc"
		#expect(self.viewModel.itemSearchResults.count == 0)
	}
	
	@Test func searchReturnsNothingWhenSearchingForWhitespaceCharacters() async throws {
		
		await self.viewModel.loadItems()
		
		self.viewModel.searchText = " "
		#expect(self.viewModel.itemSearchResults.count == 0)
	}
}
