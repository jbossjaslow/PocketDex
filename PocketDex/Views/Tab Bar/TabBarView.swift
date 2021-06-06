//
//  TabBarView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/6/21.
//

import SwiftUI
import PokeSwift

struct TabBarView: View {
	@EnvironmentObject var viewRouter: ViewRouter
	
	var body: some View {
		switch viewRouter.currentSelection {
			case .pokemon:
				StaticList<Pokemon>()
			case .type:
				StaticList<Type>()
			case .move:
				StaticList<Move>()
			case .ability:
				StaticList<Ability>()
			case .more:
				Text("More")
		}
	}
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarView()
			.environmentObject(ViewRouter(initialSelection: .pokemon))
	}
}
