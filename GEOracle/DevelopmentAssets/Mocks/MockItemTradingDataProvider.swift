//
//  MockItemTradingDataProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 16/04/2025.
//

final class MockItemTradingDataProvider: ItemTradingDataProvider {

	func fetchHistoricalTradingData(
		itemId: Int,
		stepSize: DataTimestep
	) async throws(NetworkServiceError) -> [HistoricalItemTradingData] {
		fatalError("❓ Unimplemented: \(#function)")
	}

	var fetchLatestTradingDataClosure: () throws(NetworkServiceError) -> [String : ItemTradingData] = {
		fatalError("❓ Unimplemented: \(#function)")
	}

	func fetchLatestTradingData() async throws(NetworkServiceError) -> [String : ItemTradingData] {
		try self.fetchLatestTradingDataClosure()
	}
}

extension MockItemTradingDataProvider: @unchecked Sendable {}
