//
//  VolumeChartView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/07/2025.
//

import Charts
import SwiftUI

@Observable
@MainActor
class VolumeChartViewModel {
	enum State {
		case loading
		case loaded(data: [HistoricalItemTradingData])
		case error
	}

	var state = State.loading

	private let itemID: Int
	private let itemTradingDataProvider: any ItemTradingDataProvider

	init(itemID: Int) {
		self.itemID = itemID
		self.itemTradingDataProvider = DC.shared.resolve(forType: ItemTradingDataProvider.self)!
	}

	func loadData() async {
		state = .loading

		do {
			let itemHistoricalData = try await itemTradingDataProvider.fetchHistoricalTradingData(
				itemId: itemID,
				stepSize: .fiveMinutes
			)
			state = .loaded(data: itemHistoricalData)
		} catch {
			state = .error
		}
	}
}

struct VolumeChartView: View {
	@State private var viewModel: VolumeChartViewModel

	init(itemID: Int) {
		self.viewModel = VolumeChartViewModel(itemID: itemID)
	}

	var body: some View {
		switch viewModel.state {
		case .loading:
			ProgressView()
				.task { await viewModel.loadData() }
		case .loaded(let data):
			Chart(data, id: \.date) { item in
				LineMark(
					x: .value("Data", item.date),
					y: .value("Volume", item.totalVolume),
				)
				AreaMark(
					x: .value("Data", item.date),
					y: .value("Volume", item.totalVolume),
				)
				.opacity(0.1)
			}
			.chartYScale(type: .squareRoot)
			.chartXAxis {
				AxisMarks(values: .stride(by: .hour, count: 2)) { value in
					AxisValueLabel(format: .dateTime.hour().minute())
					AxisGridLine()
					AxisTick()
				}
			}
			.chartXVisibleDomain(length: 18000)  // 5 hours
			.chartScrollPosition(initialX: data.last?.date ?? Date())
			.chartScrollableAxes(.horizontal)
		case .error:
			EmptyView()
		}
	}
}

#Preview {
	let _ = DC.shared.register(
		StubItemTradingDataProvider(delay: .seconds(1)),
		forType: ItemTradingDataProvider.self
	)

	VolumeChartView(itemID: 1)
		.frame(height: 300)
}
