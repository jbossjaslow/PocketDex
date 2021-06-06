//
//  ContentView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/2/21.
//

import SwiftUI
import PokeSwift

struct PokemonView: View {
	@State var requestURL: String
	
	@State var makingRequest: Bool = false
	@State var pokemonName: String = "Pokemon Name"
	@State var pokemonGenus: String = "Pokemon Genus"
	@State var pokemonFrontSprite: String = ""
	@State var pokemonTypes: [Type] = []
//	@State var pokemon: Pokemon? = nil
	
	@State var backgroundGradient: [Color] = [.white]
	
    var body: some View {
		VStack {
			Spacer()
			
			HStack {
				Text(pokemonName)
				
				Text("|")
					.font(.largeTitle)
				
				Text(pokemonGenus)
			}
			.padding()
			
			RemoteImageView(url: $pokemonFrontSprite)
			
			Spacer()
		}
		.onAppear {
			getPokemon()
		}
		.background(
			LinearGradient(gradient: Gradient(colors: backgroundGradient),
						   startPoint: .top,
						   endPoint: .bottom)
		)
    }
	
	func getPokemon() {
		makingRequest = true
		Pokemon.request(using: .url(requestURL)) { (_ result: Pokemon?) in
			DispatchQueue.main.async {
				guard let pokemon = result,
					  let name = pokemon.name else {
					print("Error, check input")
					self.makingRequest = false
					return
				}
				
//				self.pokemon = pokemon
				pokemonName = name
				getPokemonSpecies(pokemon: pokemon)
				getPokemonTypes(pokemon: pokemon)
				
				if let sprite = pokemon.sprites?.frontDefault {
					pokemonFrontSprite = sprite
				}
				
				makingRequest = false
			}
		}
	}
	
	func getPokemonSpecies(pokemon: Pokemon) {
		pokemon.species?.request { result in
			DispatchQueue.main.async {
				guard let species = result,
					  let genusList = species.genera else {
					print("Error, check input")
					return
				}
				
				let genusEnglish = genusList.filter {
					$0.language?.name == "en"
				}
				
				guard let genus = genusEnglish.first?.genus else {
					return
				}
				
				pokemonGenus = genus
			}
		}
	}
	
	func getPokemonTypes(pokemon: Pokemon) {
		pokemon.types?.forEach {
			$0.type?.request { result in
				DispatchQueue.main.async {
					guard let type = result else {
						print("Error, check input")
						return
					}
					
					pokemonTypes.append(type)
					self.backgroundGradient = getPokemonTypeGradient()
				}
			}
		}
	}
	
	func getPokemonTypeGradient() -> [Color] {
		guard !pokemonTypes.isEmpty else {
			return [.white]
		}
		
		return pokemonTypes.map {
			Color($0.mapAdditionalInfo()?.color ?? .white)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		PokemonView(requestURL: Pokemon.url + "1")
    }
}
