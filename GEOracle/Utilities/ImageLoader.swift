//
//  ImageLoader.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 20/04/2025.
//

import UIKit

protocol ImageProvider {
	func loadImage(from urlString: String) async -> UIImage?
}

struct ImageLoader<Cache: KeyValueCache<String, UIImage>>: ImageProvider {
	let cacheManager: Cache
	let urlSession: any URLSessionProtocol

	init(
		cacheManager: Cache,
		urlSession: some URLSessionProtocol
	) {
		self.cacheManager = cacheManager
		self.urlSession = urlSession
	}

	func loadImage(from urlString: String) async -> UIImage? {
		if let cachedValue = self.cacheManager.value(forKey: "") {
			return cachedValue
		}

		guard let url = URL(string: urlString),
              let (data, _) = try? await self.urlSession.data(for: URLRequest(url: url)),
              let image = UIImage(data: data)
		else {

			return nil
		}

		self.cacheManager.insert(image, forKey: urlString)

		return image
	}
}
