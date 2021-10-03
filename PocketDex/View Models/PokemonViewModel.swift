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
	@Published var pokemonID: String = "-1"
	@Published var pokemonGenus: String = "Pokemon Genus"
	@Published var pokemonSprites: [(name: String,
									 url: String)] = [] // (Sprite name, url)
	@Published var pokemonTypes: [Type] = []
	@Published var backgroundGradient: [Color] = [.white]
//	@Published var movesLearned: [NamedAPIResource<Move>] = []
	@Published var movesLearned: [PokemonMoveData] = []
	@Published var abilities: [PokemonAbility] = []
	@Published var stats: [(name: String,
							value: Int)] = []
	
	@Published var species: PokemonSpecies?
	@Published var chainPokemon: EvolutionChainPokemonCollection?
	
	@Published var showingStats: Bool = false
	
	var typeMaps: [TypeMap] {
		pokemonTypes.compactMap { $0.mapAdditionalInfo() }
	}
	
	@Published var makingRequest: Bool = false
	
	private var requestURL: String
	
	init(url: String,
		 name: String? = nil) {
		self.requestURL = url
		if let name = name {
			self.pokemonName = name
			#if !DEBUG
			pokemonID = ""
			#endif
		}
	}
	
	func fetchPokemon() async {
		makingRequest = true
		
		do {
			let fetchedPokemon = try await Pokemon.request(using: .url(requestURL))
			
			fetchNameAndID(from: fetchedPokemon)
			
			try await fetchSpeciesAndEvolutions(from: fetchedPokemon)
			
			try await fetchTypes(from: fetchedPokemon)
			
			fetchMoves(from: fetchedPokemon)
			
			fetchAbilities(from: fetchedPokemon)
			
			fetchSprites(from: fetchedPokemon)
			
			fetchStats(from: fetchedPokemon)
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
		
		makingRequest = false
	}
	
	private func fetchNameAndID(from fetchedPokemon: Pokemon) {
		pokemonName = fetchedPokemon.name ?? "POKEMON NAME ERROR"
		let id = fetchedPokemon.id ?? -1
		pokemonID = "#" + id.description
	}
	
	private func fetchSpeciesAndEvolutions(from fetchedPokemon: Pokemon) async throws {
		self.species = try await fetchedPokemon.species?.request()
		if let genusList = self.species?.genera {
			let genusEnglish = genusList.filter {
				$0.language?.name == "en"
			}
			pokemonGenus = genusEnglish.first?.genus ?? "GENUS ERROR"
		}
		self.chainPokemon = await EvolutionChainPokemonCollection(from: self.species)
	}
	
	private func fetchTypes(from fetchedPokemon: Pokemon) async throws {
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
	}
	
	private func fetchMoves(from fetchedPokemon: Pokemon) {
		if let moves = fetchedPokemon.moves {
			movesLearned = moves.compactMap { PokemonMoveData(move: $0) }
		}
	}
	
	private func fetchAbilities(from fetchedPokemon: Pokemon) {
		if let abilities = fetchedPokemon.abilities {
			self.abilities = abilities.sorted(by: { $0.slot ?? 0 < $1.slot ?? 1 })
		}
	}
	
	private func fetchSprites(from fetchedPokemon: Pokemon) {
		// If there are female sprites, rename default sprites to Male; else, keep genderless
		if fetchedPokemon.sprites?.frontFemale != nil,
		   fetchedPokemon.sprites?.backFemale != nil {
			pokemonSprites = [
				("Front Male", fetchedPokemon.sprites?.frontDefault ?? ""),
				("Front Male Shiny", fetchedPokemon.sprites?.frontShiny ?? ""),
				("Front Female", fetchedPokemon.sprites?.frontFemale ?? ""),
				("Front Female Shiny", fetchedPokemon.sprites?.frontShinyFemale ?? ""),
				("Back Male", fetchedPokemon.sprites?.backDefault ?? ""),
				("Back Male Shiny", fetchedPokemon.sprites?.backShiny ?? ""),
				("Back Female", fetchedPokemon.sprites?.backFemale ?? ""),
				("Back Female Shiny", fetchedPokemon.sprites?.backShinyFemale ?? ""),
			]
		} else {
			pokemonSprites = [
				("Front", fetchedPokemon.sprites?.frontDefault ?? ""),
				("Front Shiny", fetchedPokemon.sprites?.frontShiny ?? ""),
				("Back", fetchedPokemon.sprites?.backDefault ?? ""),
				("Back Shiny", fetchedPokemon.sprites?.backShiny ?? ""),
			]
		}
		pokemonSprites.removeAll { (name, url) in
			url.isEmpty
		}
	}
	
	private func fetchStats(from fetchedPokemon: Pokemon) {
		if let stats = fetchedPokemon.stats,
		   stats.count == 6 {
			self.stats = stats.map {
				return (name: $0.stat?.name ?? "ERROR",
						value: $0.baseStat ?? 0)
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
