//
//  GEOracleApp.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 27/01/2025.
//

import SwiftUI

@main
struct GEOracleApp: App {
	@State var viewModel = ItemSearchViewModel()
	var body: some Scene {
		WindowGroup {
			ItemSearchView(viewModel: self.viewModel)
		}
	}
}
