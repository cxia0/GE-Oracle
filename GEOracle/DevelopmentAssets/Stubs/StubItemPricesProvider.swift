//
//  StubItemPricesProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 29/01/2025.
//

import Foundation

struct StubItemPricesProvider: ItemPricesProvider {

	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestItemPrices { .mock }
}

extension LatestItemPrices {
	static let mock = {
		let data = [
			"1": LatestItemPrice(
				high: 22,
				highTime: 1645568542,
				low: 11,
				lowTime: 1294744271
			),
			"2": LatestItemPrice(
				high: 99,
				highTime: 1738158650,
				low: 90,
				lowTime: 1738158656
			),
			"3": LatestItemPrice(
				high: 50,
				highTime: 1738158650,
				low: 45,
				lowTime: 1738158656
			),
			"4": LatestItemPrice(
				high: 1999999999,
				highTime: 1738158650,
				low: 1888888888,
				lowTime: 1738158656
			)
		]
		return LatestItemPrices(data: data)
	}()
}
