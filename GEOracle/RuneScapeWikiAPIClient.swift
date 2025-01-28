//
//  RuneScapeWikiAPIClient.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/01/2025.
//

import Foundation

enum NetworkServiceError: Error {

	case badURL
	case networkError
	case badResponse
	case decodingError
}

class RuneScapeWikiAPIClient {
	
	private let urlSession: URLSessionProtocol
	private let dataDecoder: DataDecoder
	
	init(urlSession: some URLSessionProtocol = URLSession.shared,
		 decoder: some DataDecoder = JSONDecoder()) {
		self.urlSession = urlSession
		self.dataDecoder = decoder
	}

	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestPrices {

		guard let url = URL(string: "https://prices.runescape.wiki/api/v1/osrs/latest") else {
			throw .badURL
		}
		
		guard let (data, response) = try? await self.urlSession.data(for: URLRequest(url: url)) else {
			throw .networkError
		}
		
		guard let httpResponse = response as? HTTPURLResponse,
			  (200...299).contains(httpResponse.statusCode) else {
			throw .badResponse
		}
		
		guard let latestPrices = try? self.dataDecoder.decode(LatestPrices.self, from: data) else {
			throw .decodingError
		}
		
		return latestPrices
	}
}
