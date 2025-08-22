//
//  LatestPrices.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 28/01/2025.
//

import Foundation

struct ItemTradingDataResponse: Decodable {
    /// The keys are OSRS's item identifiers.
    let data: [String: ItemTradingData]
}

struct ItemTradingData: Decodable {
	
	let high: Int
	let highTime: Int
	let low: Int
	let lowTime: Int
}
