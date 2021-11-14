//
//  TabBar.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift

struct TabBar: View {
	
	var body: some View {
		TabView {
			StaticList<PokemonSpecies>()
				.tag(TabIcon.pokemon)
				.tabItem {
					Image(uiImage: getTabIcon(.pokemon))
					Text(TabIcon.pokemon.rawValue)
				}
			
			TypeList()
				.tag(TabIcon.type)
				.tabItem {
					Image(uiImage: getTabIcon(.type))
					Text(TabIcon.type.rawValue)
				}

			StaticList<Move>()
				.tag(TabIcon.move)
				.tabItem {
					Image(uiImage: getTabIcon(.move))
					Text(TabIcon.move.rawValue)
				}

			StaticList<Ability>()
				.tag(TabIcon.ability)
				.tabItem {
					Image(uiImage: getTabIcon(.ability))
					Text(TabIcon.ability.rawValue)
				}
			
			Text("More updates are coming in the future. Stay Tuned!")
			.tag(TabIcon.more)
			.tabItem {
				Image(uiImage: getTabIcon(.more))
				Text(TabIcon.more.rawValue)
			}
		}
	}
	
	func getTabIcon(_ selection: TabIcon) -> UIImage {
		switch selection {
			case .pokemon: return Asset.Pokeball.pokeballSmall.image
			case .type: return Asset.Pokeball.pokeballSmall.image
			case .ability: return Asset.Pokeball.pokeballSmall.image
			case .move: return Asset.Pokeball.pokeballSmall.image
			case .more: return UIImage(systemName: "list.bullet") ?? Asset.Pokeball.pokeballSmall.image
		}
	}
}

//struct TabBar: View {
//	@EnvironmentObject var viewRouter: ViewRouter
//
//	var body: some View {
//		GeometryReader { geometry in
//			VStack(spacing: 0) {
//				TabBarView()
//
//				TabBarIcons(geometry: geometry)
//			}
//			.edgesIgnoringSafeArea(.bottom)
//		}
//	}
//}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
//			.environmentObject(ViewRouter(initialSelection: .pokemon))
    }
}
