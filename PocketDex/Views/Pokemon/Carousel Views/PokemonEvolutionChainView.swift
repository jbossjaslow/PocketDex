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
					 selectedItemScale: .medium) { evo, _ in
			if let sprite = evo.frontSprite,
			   let url = evo.pokemonSpeciesURL,
			   let speciesName = evo.species?.name {
				let viewModel = PokemonViewModel(url: url)
				let isCurrentSpecies = checkIsCurrentSpecies(species: evo.species)

				VStack(spacing: 0) {
					PokemonImageView(sprite: sprite)
					
					Text(speciesName)
						.foregroundColor(.black)
						.if(isCurrentSpecies) {
							$0.bold().underline()
						}
						.padding(.top, -10)
						.padding(.bottom)
						.navigableTo(disabled: isCurrentSpecies,
									 PokemonDetail(viewModel: viewModel))
				}
			} else {
				Text("Error")
			}
		}
    }
	
	private func checkIsCurrentSpecies(species: PokemonSpecies?) -> Bool {
		species?.name ?? "ERROR: NO NAME FOUND" == viewModel.speciesInfo.name
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
