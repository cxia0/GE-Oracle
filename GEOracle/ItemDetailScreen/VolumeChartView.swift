//
//  VolumeChartView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/07/2025.
//

import Charts
import SwiftUI

struct VolumeChartView: View {
	let priceHistory: [HistoricalItemPrice]

	var body: some View {

		Chart(priceHistory, id: \.date) { item in
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
        .chartXVisibleDomain(length: 18000) // 5 hours
        .chartScrollPosition(initialX: priceHistory.last?.date ?? Date())
		.chartScrollableAxes(.horizontal)
	}
}

#Preview {
	let data = StubItemPricesProvider().fetchHistoricalData(
		itemId: 1,
		stepSize: .fiveMinutes
	)

	VolumeChartView(priceHistory: data)
        .frame(height: 300)
}
