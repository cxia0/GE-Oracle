//
//  RuneScapeWikiAPIClientTests.swift
//  GEOracleTests
//
//  Created by Chunfeng Xia on 27/01/2025.
//

import Testing
@testable import GEOracle
import Foundation

struct RuneScapeWikiAPIClientTests {
	
	let urlSession = MockURLSession()
	let decoder = MockDataDecoder()
	
	let runeScapeWikiAPIClient: RuneScapeWikiAPIClient
	
	init() {
		
		self.runeScapeWikiAPIClient = RuneScapeWikiAPIClient(
			urlSession: self.urlSession,
			decoder: self.decoder
		)
	}
	
	@Test func returnsLatestPrices() async throws {
		self.urlSession.dataClosure = { return (Data(), Self.successfulHTTPURLResponse) }
		/// I still don't really like mocking the decoder... The tests feel so "artificial".
		self.decoder.decodeClosure = { return LatestPrices(data: ["1": PriceData(high: 1, highTime: 2, low: 3, lowTime: 4)]) }
		
		let latestPrices = try await self.runeScapeWikiAPIClient.fetchLatestPrices()
		#expect(latestPrices.data.count == 1)
		
		let priceData = try #require(latestPrices.data["1"])
		
		#expect(priceData.high == 1)
		#expect(priceData.highTime == 2)
		#expect(priceData.low == 3)
		#expect(priceData.lowTime == 4)
	}
	
	@Test func throwsNetworkError() async throws {
		self.urlSession.dataClosure = { throw NSError() }
		
		await #expect(throws: NetworkServiceError.networkError) {
			try await self.runeScapeWikiAPIClient.fetchLatestPrices()
		}
	}
	
	@Test func throwsBadResponseError() async throws {
		self.urlSession.dataClosure = { return (Data(), Self.badHTTPURLResponse) }
		
		await #expect(throws: NetworkServiceError.badResponse) {
			try await self.runeScapeWikiAPIClient.fetchLatestPrices()
		}
	}
	
	@Test func throwsDecodingError() async throws {
		self.urlSession.dataClosure = { return (Data(), Self.successfulHTTPURLResponse) }
		self.decoder.decodeClosure = { throw NSError() }
		
		await #expect(throws: NetworkServiceError.decodingError) {
			try await self.runeScapeWikiAPIClient.fetchLatestPrices()
		}
	}
}

extension RuneScapeWikiAPIClientTests {
	static let successfulHTTPURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
														   statusCode: 200,
														   httpVersion: nil,
														   headerFields: nil)!
	
	static let badHTTPURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
													statusCode: 404,
													httpVersion: nil,
													headerFields: nil)!
}
