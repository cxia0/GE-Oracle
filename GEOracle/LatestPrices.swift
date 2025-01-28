//
//  LatestPrices.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 28/01/2025.
//

import Foundation

struct LatestPrices: Decodable {
	/// The keys are OSRS's item identifiers.
	let data: [String: PriceData]
}

struct PriceData: Decodable {
	
	let high: Int
	let highTime: Int
	let low: Int
	let lowTime: Int
}
