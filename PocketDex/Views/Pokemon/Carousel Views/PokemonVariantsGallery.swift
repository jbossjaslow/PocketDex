//
//  PokemonVariantsGallery.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/3/21.
//

import SwiftUI
import PokeSwift

struct PokemonVariantsGallery: View {
	@ObservedObject var viewModel: PokemonViewModel
	
	var body: some View {
		CarouselView($viewModel.variantSprites,
					 selectedItemScale: .medium) { sprite, isCurrentlySelected in
			VStack(spacing: 0) {
				PokemonImageView(sprite: sprite.spriteUrl)
					.onChange(of: isCurrentlySelected) { newValue in
						Task {
							if newValue {
								await viewModel.loadVariant(url: sprite.pokemonUrl,
															name: sprite.name)
							}
						}
					}
				
				Text(sprite.name)
					.foregroundColor(.black)
					.padding(.top, -10)
					.padding(.bottom)
			}
		}
	}
}

struct PokemonVariantsGallery_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = PokemonViewModel(speciesURL: Pokemon.url + "3")
		
		PokemonVariantsGallery(viewModel: viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
	}
}
