//
//  MockItemImageDataProvider.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 08/02/2025.
//

import Foundation
import UIKit

class MockItemImageDataProvider: ItemImageDataProvider {

	var fetchIconImageDataClosure = { (itemIconName: String) async throws(NetworkServiceError) -> Data in
		
		let iconAssetName = itemIconName.replacingOccurrences(of: " ", with: "_")

		guard let imageData = UIImage(named: iconAssetName)?.pngData() else {
			return Data()
		}
		return imageData
	}

	func fetchIconImageData(_ iconName: String) async throws(NetworkServiceError) -> Data {
		try await self.fetchIconImageDataClosure(iconName)
	}
}

extension MockItemImageDataProvider: @unchecked Sendable {}
