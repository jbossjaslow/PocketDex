//
//  PokemonEvolutionChainView.swift
//  PokemonEvolutionChainView
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI
import PokeSwift

struct PokemonEvolutionChainView: View {
	@EnvironmentObject var viewModel: PokemonViewModel
	
    var body: some View {
		CarouselView($viewModel.chainPokemonCollection.chainPokemon,
					 selectedItemScale: .medium) { evo, selected in
			if let sprite = evo.frontSprite,
			   let url = evo.pokemonURL,
			   let speciesName = evo.species?.name {
				let viewModel = PokemonViewModel(url: url)
				let isCurrentSpecies = checkIsCurrentSpecies(species: evo.species)

				PokemonImageView(sprite: sprite,
								 name: speciesName,
								 textEmphasized: isCurrentSpecies)
					.navigableTo(disabled: isCurrentSpecies || !selected,
								 PokemonDetail(viewModel: viewModel))
			} else {
				Text("Error")
			}
		}
    }
	
	private func checkIsCurrentSpecies(species: PokemonSpecies?) -> Bool {
		species?.name ?? "ERROR: NO NAME FOUND" == viewModel.species?.name ?? ""
	}
}

struct PokemonEvolutionChain_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "60")
		
		NavigationView {
			PokemonEvolutionChainView()
				.environmentObject(viewModel)
				.task {
					await viewModel.fetchPokemon()
				}
		}
    }
}
