//
//  PokemonViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/20/21.
//

import SwiftUI
import PokeSwift

class PokemonViewModel: ObservableObject {
	@Published var pokemon: Pokemon?
	@Published var pokemonName: String = "Pokemon Name"
	@Published var pokemonGenus: String = "Pokemon Genus"
	@Published var pokemonFrontSprite: String = ""
	@Published var pokemonTypes: [Type] = []
	@Published var backgroundGradient: [Color] = [.white]
	
	var typeMaps: [TypeMap] {
		pokemonTypes.compactMap { $0.mapAdditionalInfo() }
	}
	
	@Published var makingRequest: Bool = false
	
	private var requestURL: String
	
	init(url: String) {
		self.requestURL = url
	}
	
	func fetchPokemon() async {
		makingRequest = true
		
		do {
			let fetchedPokemon = try await Pokemon.request(using: .url(requestURL))
			pokemonName = fetchedPokemon.name ?? "POKEMON NAME ERROR"
			
			let fetchedSpecies = try await fetchedPokemon.species?.request()
			if let genusList = fetchedSpecies?.genera {
				let genusEnglish = genusList.filter {
					$0.language?.name == "en"
				}
				pokemonGenus = genusEnglish.first?.genus ?? "GENUS ERROR"
			}
			
			pokemonTypes.removeAll()
			if fetchedPokemon.types?.count == 1,
			   let type0 = try await fetchedPokemon.types?[0].type?.request() {
				pokemonTypes.append(type0)
			} else if fetchedPokemon.types?.count == 2,
					  let type0 = try await fetchedPokemon.types?[0].type?.request(),
					  let type1 = try await fetchedPokemon.types?[1].type?.request() {
				pokemonTypes.append(contentsOf: [type0, type1])
			}
			self.backgroundGradient = getPokemonTypeGradient()
			
			if let sprite = fetchedPokemon.sprites?.frontDefault {
				pokemonFrontSprite = sprite
			}
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
		
		makingRequest = false
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
