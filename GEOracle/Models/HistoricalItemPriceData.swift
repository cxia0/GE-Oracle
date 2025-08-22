//
//  HistoricalItemPriceData.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/07/2025.
//

import Foundation

struct HistoricalItemTradingDataResponse: Decodable {
    let itemID: Int
    let data: [HistoricalItemTradingData]

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case data
    }
}

struct HistoricalItemTradingData: Decodable {

    let date: Date
    let avgHighPrice: Int?
    let avgLowPrice: Int?
    let highPriceVolume: Int
    let lowPriceVolume: Int

    enum CodingKeys: String, CodingKey {
        case date = "timestamp"
        case avgHighPrice
        case avgLowPrice
        case highPriceVolume
        case lowPriceVolume
    }

    var totalVolume: Int { highPriceVolume + lowPriceVolume }
}
