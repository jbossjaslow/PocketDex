//
//  SpriteGallery.swift
//  SpriteGallery
//
//  Created by Josh Jaslow on 7/18/21.
//

import SwiftUI
import PokeSwift

struct SpriteGallery: View {
	@ObservedObject var viewModel: PokemonViewModel
	
	var body: some View {
		CarouselView($viewModel.pokemonSprites,
					 selectedItemScale: .medium,
					 alwaysStartAtBeginning: true) { sprite, currentlySelected in
			VStack(spacing: 0) {
				PokemonImageView(sprite: sprite.spriteUrl)
				
				Text(sprite.name)
					.foregroundColor(.black)
					.padding(.top, -10)
					.padding(.bottom)
			}
		}
	}
}

struct SpriteGallery_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = PokemonViewModel(speciesURL: Pokemon.url + "3")
		
		SpriteGallery(viewModel: viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
	}
}
