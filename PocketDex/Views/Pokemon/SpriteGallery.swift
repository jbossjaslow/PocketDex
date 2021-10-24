//
//  SpriteGallery.swift
//  SpriteGallery
//
//  Created by Josh Jaslow on 7/18/21.
//

import SwiftUI
import PokeSwift

struct SpriteGallery: View {
	@EnvironmentObject var viewModel: PokemonViewModel
	
	var body: some View {
		CarouselView($viewModel.pokemonSprites,
					 selectedItemScale: .medium) { sprite, _ in
			PokemonImageView(sprite: sprite.url,
							 name: sprite.name)
		}
	}
}

struct SpriteGallery_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "3")
		
		SpriteGallery()
			.environmentObject(viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
		//			.environmentObject(PokemonViewModel(url: Pokemon.url + "10186"))
	}
}
