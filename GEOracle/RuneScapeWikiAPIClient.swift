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

protocol ItemPricesProvider {
	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestItemPrices
}

protocol ItemDataProvider {
	func fetchItems() async throws(NetworkServiceError) -> [Item]
}

final class RuneScapeWikiAPIClient: ItemPricesProvider, ItemDataProvider {
	
	private let urlSession: URLSessionProtocol
	private let dataDecoder: DataDecoder
	
	init(urlSession: some URLSessionProtocol = URLSession.shared,
		 decoder: some DataDecoder = JSONDecoder()) {
		self.urlSession = urlSession
		self.dataDecoder = decoder
	}
	
	func fetchLatestPrices() async throws(NetworkServiceError) -> LatestItemPrices {
		
		let url = "https://prices.runescape.wiki/api/v1/osrs/latest"
		
		return try await fetchAndDecode(LatestItemPrices.self, from: url)
	}
	
	func fetchItems() async throws(NetworkServiceError) -> [Item] {
		
		let url = "https://prices.runescape.wiki/api/v1/osrs/mapping"
		
		return try await self.fetchAndDecode([Item].self, from: url)
	}
}

extension RuneScapeWikiAPIClient {
	
	private func fetchAndDecode<T>(_ type: T.Type, from urlString: String) async throws(NetworkServiceError) -> T where T : Decodable {
		guard let url = URL(string: urlString) else {
			throw .badURL
		}
		
		guard let (data, response) = try? await self.urlSession.data(for: URLRequest(url: url)) else {
			throw .networkError
		}
		
		guard let httpResponse = response as? HTTPURLResponse,
			  (200...299).contains(httpResponse.statusCode) else {
			throw .badResponse
		}
		
		do {
			
			let decodedData = try self.dataDecoder.decode(type, from: data)
			return decodedData
			
		} catch {
			// Want to bring more visibility to decoding errors because it could by caused
			// by incorrect decoding code / the data structures not matching the response from the external API.
			#if DEBUG
			print("💥", error)
			#endif
			throw NetworkServiceError.decodingError
		}
	}
}

struct Item: Identifiable, Decodable {
	
	let id: Int
	let name: String
	let description: String
	let isMembersOnly: Bool
	
	/// An item's static value in coins (predetermined by Jagex).
	///
	/// Value is used to determine how much an item is worth to Non-player characters and to the game.
	let value: Int
	
	let lowAlchemyValue: Int?
	let highAlchemyValue: Int?
	
	/// The quantity an item can be bought every 4 hours.
	let buyingLimit: Int?
	
	init(id: Int,
		 name: String,
		 description: String,
		 isMembersOnly: Bool,
		 value: Int,
		 lowAlchemyValue: Int? = nil,
		 highAlchemyValue: Int? = nil,
		 buyingLimit: Int? = nil) {

		self.id = id
		self.name = name
		self.description = description
		self.isMembersOnly = isMembersOnly
		self.value = value
		self.lowAlchemyValue = lowAlchemyValue
		self.highAlchemyValue = highAlchemyValue
		self.buyingLimit = buyingLimit
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description = "examine"
		case isMembersOnly = "members"
		case value
		case lowAlchemyValue = "lowalch"
		case highAlchemyValue = "highalch"
		case buyingLimit = "limit"
	}
}
