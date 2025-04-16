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

extension MockItemDataProvider: @unchecked Sendable {}

extension Array where Element == Item {
	static var mock: [Item] {
		[
			Item(
				id: 1438,
				name: "Air talisman",
				description: "A mysterious power emanates from the talisman...",
				isMembersOnly: false,
				value: 4,
				lowAlchemyValue: 1,
				highAlchemyValue: 2,
				buyingLimit: 11000,
				iconName: "Air talisman.png"
			),
			Item(
				id: 11802,
				name: "Armadyl godsword",
				description: "A beautiful, heavy sword.",
				isMembersOnly: true,
				value: 1250000,
				lowAlchemyValue: 500000,
				highAlchemyValue: 750000,
				buyingLimit: 8,
				iconName: "Armadyl godsword.png"
			),
			Item(
				id: 579,
				name: "Blue wizard hat",
				description: "A silly pointed hat.",
				isMembersOnly: false,
				value: 2,
				lowAlchemyValue: 1,
				highAlchemyValue: 1,
				buyingLimit: 125,
				iconName: "Blue wizard hat.png"
			),
			Item(
				id: 21009,
				name: "Dragon sword",
				description: "A razor sharp sword.",
				isMembersOnly: true,
				value: 72001,
				lowAlchemyValue: 28800,
				highAlchemyValue: 43200,
				buyingLimit: 70,
				iconName: "Dragon sword.png"
			),
			Item(
				id: 20155,
				name: "Gilded 2h sword",
				description: "A two handed sword with gold plate.",
				isMembersOnly: false,
				value: 64000,
				lowAlchemyValue: 25600,
				highAlchemyValue: 38400,
				buyingLimit: 70,
				iconName: "Gilded 2h sword.png"
			),
			Item(
				id: 1511,
				name: "Logs",
				description: "A number of wooden logs.",
				isMembersOnly: false,
				value: 4,
				lowAlchemyValue: 1,
				highAlchemyValue: 2,
				buyingLimit: 15000,
				iconName: "Logs.png"
			),
			Item(
				id: 859,
				name: "Magic longbow",
				description: "A nice sturdy magical bow.",
				isMembersOnly: true,
				value: 2560,
				lowAlchemyValue: 1024,
				highAlchemyValue: 1536,
				buyingLimit: 18000,
				iconName: "Magic longbow.png"
			),
			Item(
				id: 1201,
				name: "Rune kiteshield",
				description: "A large metal shield.",
				isMembersOnly: false,
				value: 54400,
				lowAlchemyValue: 21760,
				highAlchemyValue: 32640,
				buyingLimit: 70,
				iconName: "Rune kiteshield.png"
			),
			Item(
				id: 1289,
				name: "Rune sword",
				description: "A razor sharp sword.",
				isMembersOnly: false,
				value: 20800,
				lowAlchemyValue: 8320,
				highAlchemyValue: 12480,
				buyingLimit: 70,
				iconName: "Rune sword.png"
			),
			Item(
				id: 1735,
				name: "Shears",
				description: "For shearing sheep.",
				isMembersOnly: false,
				value: 1,
				lowAlchemyValue: 1,
				highAlchemyValue: 1,
				buyingLimit: 40,
				iconName: "Shears.png"
			),
			Item(
				id: 1617,
				name: "Uncut diamond",
				description: "This would be worth more cut.",
				isMembersOnly: false,
				value: 200,
				lowAlchemyValue: 80,
				highAlchemyValue: 120,
				buyingLimit: 10000,
				iconName: "Uncut diamond.png"
			)
		]
	}
}
