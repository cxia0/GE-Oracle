//
//  MockItemPricesProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 16/04/2025.
//

final class MockItemPricesProvider: ItemPricesProvider {

	func fetchHistoricalData(
		itemId: Int,
		stepSize: HistoricalDataTimestep
	) async throws(NetworkServiceError) -> [HistoricalItemPrice] {
		fatalError("❓ Unimplemented: \(#function)")
	}

	var fetchLatestPricesClosure: () throws(NetworkServiceError) -> LatestItemPrices = {
		fatalError("❓ Unimplemented: \(#function)")
	}

	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestItemPrices {
		try self.fetchLatestPricesClosure()
	}
}

extension MockItemPricesProvider: @unchecked Sendable {}
