//
//  ViewRouter.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/6/21.
//

import SwiftUI

enum TabIcon: String, CaseIterable {
	case pokemon = "Pokemon"
	case type = "Type"
	case move = "Move"
	case ability = "Ability"
	case more = "More"
}

class ViewRouter: ObservableObject {
	@Published var currentSelection: TabIcon
	
	init(initialSelection: TabIcon = .pokemon) {
		self.currentSelection = initialSelection
	}
	
	func getTabIcon(_ selection: TabIcon) -> UIImage {
		switch selection {
			case .pokemon: return Asset.Pokeball.pokeballSimple.image
			case .type: return Asset.Pokeball.pokeballSimple.image
			case .ability: return Asset.Pokeball.pokeballSimple.image
			case .move: return Asset.Pokeball.pokeballSimple.image
			case .more: return UIImage(systemName: "list.bullet") ?? Asset.Pokeball.pokeballSimple.image
		}
	}
}
