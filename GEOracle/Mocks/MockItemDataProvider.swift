//
//  MockItemDataProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 29/01/2025.
//

import Foundation

final class MockItemDataProvider: ItemDataProvider {
	
	var fetchItemsClosure: () throws(NetworkServiceError) -> [Item] = { .mock }
	func fetchItems() async throws(NetworkServiceError) -> [Item] { try self.fetchItemsClosure() }
}

extension Array where Element == Item {
	static var mock: [Item] {
		[
			Item(id: 1, name: "Bow", description: "A cool bow", isMembersOnly: true, value: 10, lowAlchemyValue: 100, highAlchemyValue: 50, buyingLimit: 10),
			Item(id: 2, name: "Sword", description: "A sharp sword", isMembersOnly: true, value: 10, lowAlchemyValue: 100, highAlchemyValue: 50, buyingLimit: 10),
			Item(id: 3, name: "Shield", description: "A sturdy shield", isMembersOnly: true, value: 10, lowAlchemyValue: 100, highAlchemyValue: 50, buyingLimit: 10),
			Item(id: 4, name: "Amulet", description: "A shiny amulet", isMembersOnly: false, value: 5, lowAlchemyValue: 50, highAlchemyValue: 25, buyingLimit: 20),
			Item(id: 5, name: "Staff", description: "A magical staff", isMembersOnly: true, value: 15, lowAlchemyValue: 150, highAlchemyValue: 75, buyingLimit: 5),
			Item(id: 6, name: "Potion", description: "A healing potion", isMembersOnly: false, value: 2, lowAlchemyValue: 20, highAlchemyValue: 10, buyingLimit: 100),
			Item(id: 7, name: "Draconic Bow", description: "A bow made from dragon bones.", isMembersOnly: true, value: 2000, lowAlchemyValue: 1000, highAlchemyValue: 3000, buyingLimit: 1),
			Item(id: 8, name: "Elven Bow", description: "A bow made by elves.", isMembersOnly: true, value: 2000, lowAlchemyValue: 1000, highAlchemyValue: 3000, buyingLimit: 1)
		]
	}
}
