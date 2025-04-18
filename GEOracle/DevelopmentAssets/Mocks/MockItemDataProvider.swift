//
//  MockItemDataProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 16/04/2025.
//

final class MockItemDataProvider: ItemDataProvider {

	var fetchItemsClosure: () throws(NetworkServiceError) -> [Item] = {
		fatalError("❓ Unimplemented: \(#function)")
	}

	func fetchItems() async throws(NetworkServiceError) -> [Item] {
		try self.fetchItemsClosure()
	}
}

extension MockItemDataProvider: @unchecked Sendable {}

