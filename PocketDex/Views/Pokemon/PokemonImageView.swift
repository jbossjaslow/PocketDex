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
	let name: String
	let textEmphasized: Bool
	
	init(sprite: String,
		 name: String,
		 textEmphasized: Bool = false) {
		self.sprite = sprite
		self.name = name
		self.textEmphasized = textEmphasized
	}
	
    var body: some View {
		VStack(spacing: 0) {
			AsyncImage(url: URL(string: sprite)) { image in
				image
					.resizable()
					.frame(width: 200)
					.clipped()
					.shadow(radius: 4)
			} placeholder: {
				LoadingView()
			}
			
			Text(name)
				.foregroundColor(.black)
				.if(textEmphasized) {
					$0.bold().underline()
				}
				.padding(.top, -10)
				.padding(.bottom)
		}
	}
}

struct PokemonImageView_Previews: PreviewProvider {
    static var previews: some View {
		PokemonImageView(sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
						 name: "Bulbasaur")
    }
}
