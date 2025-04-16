//
//  Item.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 05/02/2025.
//

import Foundation

struct Item: Identifiable, Decodable {

	let id: Int
	let name: String
	let description: String
	let isMembersOnly: Bool

	/// An item's static value in coins (predetermined by Jagex).
	///
	/// Value is used to determine how much an item is worth to Non-player characters and to the game.
	let value: Int

	let lowAlchemyValue: Int?
	let highAlchemyValue: Int?

	/// The quantity an item can be bought every 4 hours.
	let buyingLimit: Int?
	let iconName: String

	init(
		id: Int,
		name: String,
		description: String,
		isMembersOnly: Bool,
		value: Int,
		lowAlchemyValue: Int? = nil,
		highAlchemyValue: Int? = nil,
		buyingLimit: Int? = nil,
		iconName: String = ""
	) {

		self.id = id
		self.name = name
		self.description = description
		self.isMembersOnly = isMembersOnly
		self.value = value
		self.lowAlchemyValue = lowAlchemyValue
		self.highAlchemyValue = highAlchemyValue
		self.buyingLimit = buyingLimit
		self.iconName = iconName
	}

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description = "examine"
		case isMembersOnly = "members"
		case value
		case lowAlchemyValue = "lowalch"
		case highAlchemyValue = "highalch"
		case buyingLimit = "limit"
		case iconName = "icon"
	}
}
