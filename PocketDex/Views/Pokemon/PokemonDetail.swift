//
//  PokemonDetail.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/2/21.
//

import SwiftUI
import PokeSwift

struct PokemonDetail: View {
	@ObservedObject var viewModel: PokemonViewModel
	
    var body: some View {
		ScrollView {
			VStack {
				Spacer()
				
				//Name & Genus
				Text(viewModel.pokemonName.capitalizingFirstLetter())
					.font(.system(size: 48))
				
				Text(viewModel.pokemonGenus)
					.font(.largeTitle)
				
				//Abilities
				HStack(spacing: 5) {
					ForEach(viewModel.abilities, id: \.slot) { ability in
						NavigationLink(destination: AbilityDetail(viewModel: AbilityViewModel(name: ability.ability?.name ?? ""))) {
							HStack {
								Text(ability.ability?.name ?? "")
								
								if let isHidden = ability.isHidden,
								   isHidden == true {
									Image(systemName: "h.circle.fill")
										.scaleEffect(1.5)
								}
							}
						}
						.buttonStyle(.bordered)
						.tint(.white)
					}
				}
				
				//Types
				HStack(spacing: 5) {
					ForEach(viewModel.typeMaps, id: \.name) { typeMap in
						NavigationLink(destination: TypeDetail().environmentObject(TypeViewModel(typeMap: typeMap))) {
							Image(uiImage: typeMap.iconRectangular)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.border(Color.white, width: 2)
						}
					}
				}
				.padding(.horizontal)
				
				//Sprite
				SpriteGallery()
					.environmentObject(viewModel)
				
				PopOutList<Move>(title: "Moves learned by this Pokemon",
								 resources: $viewModel.movesLearned)
					.padding(.horizontal)
			}
		}
		.task {
			await viewModel.fetchPokemon()
		}
		.background(
			LinearGradient(gradient: Gradient(colors: viewModel.backgroundGradient),
						   startPoint: .top,
						   endPoint: .bottom)
				.edgesIgnoringSafeArea([.top, .leading, .trailing])
		)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			PokemonDetail(viewModel: PokemonViewModel(url: Pokemon.url + "1"))
		}
    }
}
