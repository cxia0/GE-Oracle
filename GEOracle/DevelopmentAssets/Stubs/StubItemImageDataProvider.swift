//
//  StubItemImageDataProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 08/02/2025.
//

import UIKit

struct StubItemImageDataProvider: ItemImageDataProvider {

	func fetchIconImageData(_ iconName: String) async throws(NetworkServiceError) -> Data {
		let iconAssetName = iconName.replacingOccurrences(of: " ", with: "_")

		guard let imageData = UIImage(named: iconAssetName)?.pngData() else {
			return Data()
		}
		return imageData
	}
}
