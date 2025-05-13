//
//  SearchBarView.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 29/01/2025.
//

import SwiftUI

struct SearchBarView: View {
	@Binding var searchText: String
	var body: some View {
		HStack {
			Image(systemName: "magnifyingglass")
			TextField("Search", text: self.$searchText)
				.textFieldStyle(.plain) /// This stops `searchText`'s `didSet` from running twice.
		}
		.padding(10)
		.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
	}
}

#Preview {
	@Previewable @State var searchText = ""
	SearchBarView(searchText: $searchText)
}
