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
					 selectedItemScale: .medium) { sprite, _ in
			VStack(spacing: 0) {
				PokemonImageView(sprite: sprite.spriteUrl)
				
				Button {
					Task {
						await viewModel.loadVariant(url: sprite.pokemonUrl,
													name: sprite.name)
					}
				} label: {
					Text(sprite.name)
						.foregroundColor(.black)
						.if(isCurrentSpecies(spriteName: sprite.name)) {
							$0.bold().underline()
						}
						.padding(.top, -10)
						.padding(.bottom)
				}
				.disabled(isCurrentSpecies(spriteName: sprite.name))
			}
		}
	}
	
	func isCurrentSpecies(spriteName: String) -> Bool {
		spriteName == viewModel.displayName
	}
}

struct PokemonVariantsGallery_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "3")
		
		PokemonVariantsGallery(viewModel: viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
	}
}
