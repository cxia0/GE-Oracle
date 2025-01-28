//
//  URLSessionMock.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 28/01/2025.
//

import Foundation

class MockURLSession: URLSessionProtocol {
	
	var dataClosure: () throws -> (Data, URLResponse) = { throw MockError.unimplementedFunction }
	
	func data(for: URLRequest) async throws -> (Data, URLResponse) {

		try self.dataClosure()
	}
}
