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
	@Published var pokemonSprites: [(name: String,
									 url: String)] = [] // (Sprite name, url)
	@Published var pokemonTypes: [Type] = []
	@Published var backgroundGradient: [Color] = [.white]
	@Published var movesLearned: [NamedAPIResource<Move>] = []
	@Published var abilities: [PokemonAbility] = []
	@Published var stats: [(name: String,
							value: Int)] = []
	
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
			backgroundGradient = [.white]
			self.backgroundGradient = getPokemonTypeGradient()
			
			if let moves = fetchedPokemon.moves {
				movesLearned = moves.compactMap { $0.move }
			}
			
			if let abilities = fetchedPokemon.abilities {
				self.abilities = abilities.sorted(by: { $0.slot ?? 0 < $1.slot ?? 1 })
			}
			
			pokemonSprites = [
				("Front", fetchedPokemon.sprites?.frontDefault ?? ""),
				("Front Shiny", fetchedPokemon.sprites?.frontShiny ?? ""),
				("Female", fetchedPokemon.sprites?.frontFemale ?? ""),
				("Front Female Shiny", fetchedPokemon.sprites?.frontShinyFemale ?? ""),
				("Back", fetchedPokemon.sprites?.backDefault ?? ""),
				("Back Shiny", fetchedPokemon.sprites?.backShiny ?? ""),
				("Back Female", fetchedPokemon.sprites?.backFemale ?? ""),
				("Back Female Shiny", fetchedPokemon.sprites?.backShinyFemale ?? ""),
			]
			pokemonSprites.removeAll { (name, url) in
				url.isEmpty
			}
			
			if let stats = fetchedPokemon.stats,
			   stats.count == 6 {
				self.stats = stats.map {
					return (name: $0.stat?.name ?? "ERROR",
							value: $0.baseStat ?? 0)
				}
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
