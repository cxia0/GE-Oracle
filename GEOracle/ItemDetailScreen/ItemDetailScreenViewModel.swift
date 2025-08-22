//
//  ItemDetailScreenViewModel.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 22/08/2025.
//

import Observation

@MainActor
@Observable
class ItemDetailScreenViewModel {
	let item: Item

	init(item: Item) { self.item = item }

	func formattedItemValue(property keyPath: KeyPath<Item, Int?>) -> String {
		guard let value = self.item[keyPath: keyPath] else {
			return "?"
		}

		return value.formatted()
	}
}
