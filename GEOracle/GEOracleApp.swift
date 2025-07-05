//
//  GEOracleApp.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/01/2025.
//

import SwiftUI

@main
struct GEOracleApp: App {

	@State private var path = NavigationPath()

	init() {
		DC.shared.register(RuneScapeWikiAPIClient(), forType: ItemPricesProvider.self)
		DC.shared.register(RuneScapeWikiAPIClient(), forType: ItemImageDataProvider.self)
		DC.shared.register(RuneScapeWikiAPIClient(), forType: ItemDataProvider.self)
	}

	var body: some Scene {
		WindowGroup {
			NavigationStack(path: self.$path) {
				ItemSearchView()
					.navigationDestination(for: String.self) { string in
						Text(string)
					}
			}
		}
	}
}
