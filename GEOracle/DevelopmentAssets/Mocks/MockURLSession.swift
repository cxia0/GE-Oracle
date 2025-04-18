//
//  URLSessionMock.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 28/01/2025.
//

import Foundation

final class MockURLSession: URLSessionProtocol {
	
	var dataClosure: () throws -> (Data, URLResponse) = { fatalError("❓ Unimplemented: \(#function)") }

	func data(for: URLRequest) async throws -> (Data, URLResponse) {

		try self.dataClosure()
	}
}

extension MockURLSession: @unchecked Sendable {}
