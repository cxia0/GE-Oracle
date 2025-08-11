//
//  StubItemPricesProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 29/01/2025.
//

import Foundation

struct StubItemPricesProvider: ItemPricesProvider {

    let delay: Duration

    init(delay: Duration = .zero) {
        self.delay = delay
    }

	func fetchLatestPrices() -> LatestItemPrices { .mock }

	func fetchHistoricalData(
		itemId: Int,
		stepSize: HistoricalDataTimestep,
	) async -> [HistoricalItemPrice] {
        try? await Task.sleep(for: delay)

		do {
			guard let url = Bundle.main.url(forResource: "five_minutes", withExtension: "json") else {
				return []
			}

			let jsonData = try Data(contentsOf: url)

			let decoder = JSONDecoder()
			let data = try decoder.decode(HistoricalItemPricesResponse.self, from: jsonData)

			return data.data
		} catch {
			debugPrint(error)
			return []
		}
	}
}

extension LatestItemPrices {
	static let mock = {
		let data = [
			"1": LatestItemPrice(
				high: 22,
				highTime: 1_645_568_542,
				low: 11,
				lowTime: 1_294_744_271
			),
			"2": LatestItemPrice(
				high: 99,
				highTime: 1_738_158_650,
				low: 90,
				lowTime: 1_738_158_656
			),
			"3": LatestItemPrice(
				high: 50,
				highTime: 1_738_158_650,
				low: 45,
				lowTime: 1_738_158_656
			),
			"4": LatestItemPrice(
				high: 1_999_999_999,
				highTime: 1_738_158_650,
				low: 1_888_888_888,
				lowTime: 1_738_158_656
			),
		]
		return LatestItemPrices(data: data)
	}()
}
