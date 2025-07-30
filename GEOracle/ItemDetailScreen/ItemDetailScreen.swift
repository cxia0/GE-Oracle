//
//  ItemDetailScreen.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 26/07/2025.
//

import SwiftUI

@MainActor
@Observable
class ItemDetailScreenViewModel {
    let item: Item
    let itemPricesProvider: ItemPricesProvider
    var itemHistoricalData: [HistoricalItemPrice]?

    init(item: Item) {
        self.item = item
        self.itemPricesProvider = DC.shared.resolve(forType: ItemPricesProvider.self)!
    }

    func loadHistoricalData() async {
        itemHistoricalData = try? await itemPricesProvider.fetchHistoricalData(
            itemId: item.id,
            stepSize: .fiveMinutes
        )
    }
}

struct ItemDetailScreen: View {
    @State private var viewModel: ItemDetailScreenViewModel

    init(item: Item) {
        self.viewModel = ItemDetailScreenViewModel(item: item)
    }

	var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(self.viewModel.item.name)
                        .font(.headline)
                }
                Spacer()
                ItemIconImageView(iconName: self.viewModel.item.iconName)
                    .frame(width: 40)
            }
            .padding(.bottom, 16)
            if let itemHistoricalData = viewModel.itemHistoricalData {

                VolumeChartView(priceHistory: itemHistoricalData)
                    .frame(height: 250)
            }
        }
        .padding()
        .task {
            await self.viewModel.loadHistoricalData()
        }
	}
}

#if DEBUG
#Preview {
	let _ = DC.shared.register(
		StubItemImageDataProvider(), forType: ItemImageDataProvider.self
    )

    let _ = DC.shared.register(
        StubItemPricesProvider(), forType: ItemPricesProvider.self
    )

	let items = StubItemDataProvider().fetchItems()
	ItemDetailScreen(item: items[0])
}
#endif
