//
//  PokemonEvolutionChainView.swift
//  PokemonEvolutionChainView
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI
import PokeSwift

struct PokemonEvolutionChainView: View {
	@ObservedObject var viewModel: PokemonViewModel
	
    var body: some View {
		CarouselView($viewModel.chainPokemonCollection.chainPokemon,
					 selectedItemScale: .medium,
					 indexToScrollTo: $viewModel.chainPokemonCollection.currentPokemonIndex) { evo, isCurrentlySelected in
			if let sprite = evo.frontSprite,
			   let url = evo.pokemonSpeciesURL,
			   let speciesName = evo.species?.name {
				VStack(spacing: 0) {
					PokemonImageView(sprite: sprite)
						.onChange(of: isCurrentlySelected) { newValue in
							Task {
								if newValue {
									await viewModel.loadEvolution(url: url,
																  name: speciesName)
								}
							}
						}
					
					Text(speciesName)
						.foregroundColor(.black)
						.padding(.top, -10)
						.padding(.bottom)
				}
			} else {
				Text("Error")
			}
		}
    }
}

struct PokemonEvolutionChain_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "60")
		
		NavigationView {
			PokemonEvolutionChainView(viewModel: viewModel)
				.task {
					await viewModel.fetchPokemon()
				}
		}
    }
}
