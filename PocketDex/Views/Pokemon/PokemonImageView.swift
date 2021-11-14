//
//  PokemonImageView.swift
//  PokemonImageView
//
//  Created by Josh Jaslow on 9/5/21.
//

import SwiftUI
import PokeSwift

struct PokemonImageView: View {
	let sprite: String
	
	init(sprite: String) {
		self.sprite = sprite
	}
	
    var body: some View {
		RemoteImageView(url: sprite) { image in
			image
				.resizable()
				.scaledToFit()
//				.frame(width: 200)
				.clipped()
				.shadow(radius: 4)
		} placeholder: {
			LoadingView()
				.frame(width: 200)
		}

	}
}

struct PokemonImageView_Previews: PreviewProvider {
    static var previews: some View {
		PokemonImageView(sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
    }
}
