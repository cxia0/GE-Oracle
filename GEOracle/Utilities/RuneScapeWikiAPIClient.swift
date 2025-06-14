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

protocol ItemPricesProvider: Sendable {
	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestItemPrices
}

protocol ItemDataProvider: Sendable {
	func fetchItems() async throws(NetworkServiceError) -> [Item]
}

protocol ItemImageDataProvider: Sendable {
	func fetchIconImageData(_ iconName: String) async throws(NetworkServiceError) -> Data
}

struct RuneScapeWikiAPIClient: ItemPricesProvider, ItemDataProvider, ItemImageDataProvider {

	private let urlSession: URLSessionProtocol
	private let dataDecoder: DataDecoder

	private let itemDataEndpoint = "https://prices.runescape.wiki/api/v1/osrs/"
	private let itemImagesEndpoint = "https://oldschool.runescape.wiki/images/"

	init(
		urlSession: some URLSessionProtocol = URLSession.shared,
		decoder: some DataDecoder = JSONDecoder()
	) {
		self.urlSession = urlSession
		self.dataDecoder = decoder
	}

	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestItemPrices {

		let url = self.itemDataEndpoint + "latest"

		return try await fetchAndDecode(LatestItemPrices.self, from: url)
	}

	func fetchItems() async throws(NetworkServiceError) -> [Item] {

		let url = self.itemDataEndpoint + "mapping"

		return try await self.fetchAndDecode([Item].self, from: url)
	}

	func fetchIconImageData(_ iconName: String) async throws(NetworkServiceError) -> Data {

		let url = self.itemImagesEndpoint + iconName.replacingOccurrences(of: " ", with: "_")

		return try await self.fetchData(from: url)
	}
}

extension RuneScapeWikiAPIClient {

	private func fetchData(from urlString: String) async throws(NetworkServiceError) -> Data {

		guard let url = URL(string: urlString) else {
			throw .badURL
		}

		let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
		guard let (data, response) = try? await self.urlSession.data(for: urlRequest) else {
			throw .networkError
		}

		guard let httpResponse = response as? HTTPURLResponse,
				(200...299).contains(httpResponse.statusCode) else {
			throw .badResponse
		}

		return data
	}

	private func fetchAndDecode<T>(
		_ type: T.Type,
		from urlString: String
	) async throws(NetworkServiceError) -> T where T: Decodable {

		let data = try await self.fetchData(from: urlString)

		do {
			return try self.dataDecoder.decode(type, from: data)
		} catch {
			// Want to bring more visibility to decoding errors because it could by caused
			// by incorrect decoding code / the data structures not matching the response from the external API.
			#if DEBUG
			debugPrint("💥", error)
			#endif
			throw NetworkServiceError.decodingError
		}
	}
}
