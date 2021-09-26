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
		ScrollView(.horizontal) {
			ScrollViewReader { scrollProxy in
				HStack(spacing: 0) {
					ForEach(viewModel.pokemonSprites, id: \.url) { (spriteName,
																	spriteURL) in
						GeometryReader { geometryProxy in
							PokemonImageView(proxy: geometryProxy,
											 sprite: spriteURL,
											 name: spriteName)
							.onTapGesture {
								withAnimation(.easeOut(duration: 0.1)) {
									scrollProxy.scrollTo(spriteURL,
														 anchor: .center)
								}
							}
						}
//						.background(.red)
						.frame(width: 200)
					}
				}
			}
		}
		.frame(height: 200)
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
