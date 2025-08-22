//
//  MockItemTradingDataProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 16/04/2025.
//

final class MockItemTradingDataProvider: ItemTradingDataProvider {

	func fetchHistoricalData(
        itemID: Int,
		stepSize: DataTimestep
	) async throws(NetworkServiceError) -> [HistoricalItemTradingData] {
		fatalError("❓ Unimplemented: \(#function)")
	}

	var fetchLatestDataClosure: () throws(NetworkServiceError) -> [String : ItemTradingData] = {
		fatalError("❓ Unimplemented: \(#function)")
	}

	func fetchLatestData() async throws(NetworkServiceError) -> [String : ItemTradingData] {
		try self.fetchLatestDataClosure()
	}
}

extension MockItemTradingDataProvider: @unchecked Sendable {}
