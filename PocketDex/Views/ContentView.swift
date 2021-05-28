//
//  ContentView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/2/21.
//

import SwiftUI
import PokeSwift

struct ContentView: View {
	@State var makingRequest: Bool = false
	@State var pokemonName: String = "Pokemon Name"
	@State var pokemonGenus: String = "Pokemon Genus"
	@State var pokemonFrontSprite: String = ""
	
	@State private var lastPokemonSearched: Int = 0
	
    var body: some View {
		VStack {
			HStack {
				Text(pokemonName)
				
				Text("|")
					.font(.largeTitle)
				
				Text(pokemonGenus)
			}
			.padding()
			.overlay(
				HStack {
					if makingRequest {
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle())
					}
				}
			)
			
			RemoteImageView(url: $pokemonFrontSprite)
			
			Button {
				getRandomPokemon()
			} label: {
				Text("Get a random pokemon")
			}
			.disabled(makingRequest)
		}
    }
	
	func getRandomPokemon() {
		//max pokemon is 898 (does not include forms)
		//pokemon forms range from 10001 to 10220
		makingRequest = true
//		let rand = Int.random(in: 1...898)
		var rand = Int.random(in: 1...5)
		while rand == lastPokemonSearched {
			rand = Int.random(in: 1...5)
		}
		lastPokemonSearched = rand
		print(rand)
		Pokemon.request(using: .id(rand)) { (_ result: Pokemon?) in
			guard let pokemon = result,
				  let name = pokemon.name else {
				print("Error, check input")
				makingRequest = false
				return
			}
			
			pokemonName = name
			getPokemonSpecies(pokemon: pokemon)
			
			if let sprite = pokemon.sprites?.frontDefault {
				pokemonFrontSprite = sprite
			}
			
			makingRequest = false
		}
	}
	
	func getPokemonSpecies(pokemon: Pokemon) {
		pokemon.species?.request { result in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
