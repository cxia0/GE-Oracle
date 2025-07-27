//
//  HistoricalItemPriceData.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/07/2025.
//

import Foundation

struct HistoricalItemPricesResponse: Decodable {
    let itemID: Int
    let data: [HistoricalItemPrice]

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case data
    }
}

struct HistoricalItemPrice: Decodable {

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
