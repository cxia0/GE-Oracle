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

	func formattedItemValue(property keyPath: KeyPath<Item, Int?>) -> String {
		guard let value = self.item[keyPath: keyPath] else {
			return "?"
		}

		return value.formatted()
	}
}

struct ItemDetailScreen: View {
	@State private var viewModel: ItemDetailScreenViewModel

	init(item: Item) {
		self.viewModel = ItemDetailScreenViewModel(item: item)
	}

	var body: some View {
		LazyVStack(spacing: 16) {

			// Header with name, description, and icon
			HStack {
				VStack(alignment: .leading) {
					Text("11000 GP")
						.font(.title)
						.fontWeight(.bold)

					HStack {
						Group {
							Image(systemName: "arrow.up.forward")
								.padding(.trailing, -4)
							Text("330 GP · 3.0%")
						}
						.fontWeight(.medium)
						.foregroundStyle(.green)

						Text("Today")
							.foregroundStyle(.secondary)
					}
					.font(.subheadline)
				}
				Spacer()
				ItemIconImageView(iconName: viewModel.item.iconName)
			}

			// Item stats
			HStack(spacing: 16) {
				Group {
					VStack(spacing: 8) {
						HStack {
							Label("Value", systemImage: "dollarsign.circle")
							Spacer()
							Text(viewModel.formattedItemValue(property: \.value))
						}

						HStack {
							Label("Limit", systemImage: "cart.badge.clock.fill")
							Spacer()
							Text(viewModel.formattedItemValue(property: \.buyingLimit))
						}
					}

					VStack(spacing: 8) {
						HStack {
							Label("Low Alch.", systemImage: "flame")
							Spacer()
							Text(viewModel.formattedItemValue(property: \.lowAlchemyValue))
						}
						HStack {
							Label("High Alch.", systemImage: "flame.fill")
							Spacer()
							Text(viewModel.formattedItemValue(property: \.highAlchemyValue))
						}
					}
				}
				.padding(12)
				.roundedBorder(style: .separator, cornerRadius: 8, lineWidth: 0.75)
				.font(.subheadline)
			}

            VolumeChartView(itemID: viewModel.item.id)
                .frame(height: 224)
                .padding(.top, 8)
		}
		.padding()
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

	let item = Item(
		id: 1438,
		name: "Air talisman",
		description: "A mysterious power emanates from the talisman...",
		isMembersOnly: false,
		value: 11250,
		lowAlchemyValue: 76,
		highAlchemyValue: 114,
		buyingLimit: 11000,
		iconName: "Air talisman.png"
	)

	ItemDetailScreen(item: item)

}
#endif
