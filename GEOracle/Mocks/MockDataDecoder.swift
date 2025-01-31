//
//  MockDataDecoder.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 28/01/2025.
//

import Foundation

final class MockDataDecoder: DataDecoder {
	
	var decodeClosure: () throws -> Any = { throw MockError.unimplementedFunction }

	func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {

		let data = try self.decodeClosure()
		
		guard let data = data as? T else {
			throw MockError.typeMismatch("\(#function): return value does not match the type specified by the function call")
		}
		return data
	}
}
