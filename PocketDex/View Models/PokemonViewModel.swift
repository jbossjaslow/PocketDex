//
//  PokemonViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/20/21.
//

import SwiftUI
import PokeSwift

class PokemonViewModel: ObservableObject {
//	@Published var pokemon: Pokemon?
	@Published var speciesInfo: SpeciesInfo
	@Published var pokemonSprites: [SpriteReference] = [] // (Sprite name, url)
	@Published var pokemonTypes: [Type] = []
	@Published var backgroundGradient: [Color] = [.white]
	@Published var movesLearned: [PokemonMoveData] = []
	@Published var abilities: [PokemonAbility] = []
	@Published var stats: [(name: String,
							value: Int)] = []
	
	@Published var chainPokemonCollection: EvolutionChainPokemonCollection
	
	@Published var showingStats: Bool = false
	
	var typeMaps: [TypeMap] {
		pokemonTypes.compactMap { $0.mapAdditionalInfo() }
	}
	
	@Published var makingRequest: Bool = false
	
	private var requestURL: String
	
	private enum RequestErrors: Error {
		case noDefaultPokemonFound
	}
	
	init(url: String,
		 name: String? = nil) {
		self.requestURL = url
		self.chainPokemonCollection = EvolutionChainPokemonCollection()
		self.speciesInfo = SpeciesInfo()
		if let name = name {
			speciesInfo.name = name
		}
	}
	
	@MainActor
	func fetchPokemon() async {
		makingRequest = true
		defer { makingRequest = false }
		
		do {
			let defaultPokemon = try await fetchSpeciesAndEvolutions()
			
			let fetchedPokemon = try await defaultPokemon.request()
			
			try await fetchTypes(from: fetchedPokemon)
			
			fetchMoves(from: fetchedPokemon)
			
			fetchAbilities(from: fetchedPokemon)
			
			fetchSprites(from: fetchedPokemon)
			
			fetchStats(from: fetchedPokemon)
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
	
	@MainActor
	private func fetchSpeciesAndEvolutions() async throws -> NamedAPIResource<Pokemon> {
		let fetchedSpecies = try await PokemonSpecies.request(using: .url(requestURL))
		self.speciesInfo = SpeciesInfo(from: fetchedSpecies)
		self.chainPokemonCollection = await EvolutionChainPokemonCollection(from: fetchedSpecies)
		if let varieties = fetchedSpecies.varieties,
		   let defaultPokemon = varieties.first(where: { $0.isDefault ?? false })?.pokemon {
			   return defaultPokemon
		   } else {
			   throw RequestErrors.noDefaultPokemonFound
		   }
	}
	
	@MainActor
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
		
		self.backgroundGradient = getPokemonTypeGradient()
	}
	
	@MainActor
	func getPokemonTypeGradient() -> [Color] {
		guard !pokemonTypes.isEmpty else {
			return [.white]
		}
		
		return pokemonTypes.map {
			Color($0.mapAdditionalInfo()?.color ?? .white)
		}
	}
	
	@MainActor
	private func fetchMoves(from fetchedPokemon: Pokemon) {
		if let moves = fetchedPokemon.moves {
			for gen in VersionGroupName.allCases {
				movesLearned.append(contentsOf: moves.compactMap {
					PokemonMoveData(move: $0,
									gen: gen.rawValue)
				})
			}
		}
	}
	
	@MainActor
	private func fetchAbilities(from fetchedPokemon: Pokemon) {
		if let abilities = fetchedPokemon.abilities {
			self.abilities = abilities.sorted(by: { $0.slot ?? 0 < $1.slot ?? 1 })
		}
	}
	
	@MainActor
	private func fetchSprites(from fetchedPokemon: Pokemon) {
		// If there are female sprites, rename default sprites to Male; else, keep genderless
		if fetchedPokemon.sprites?.frontFemale != nil,
		   fetchedPokemon.sprites?.backFemale != nil {
			pokemonSprites = [
				SpriteReference(name: "Front Male",
								url: fetchedPokemon.sprites?.frontDefault ?? ""),
				SpriteReference(name: "Front Male Shiny",
								url: fetchedPokemon.sprites?.frontShiny ?? ""),
				SpriteReference(name: "Front Female",
								url: fetchedPokemon.sprites?.frontFemale ?? ""),
				SpriteReference(name: "Front Female Shiny",
								url: fetchedPokemon.sprites?.frontShinyFemale ?? ""),
				SpriteReference(name: "Back Male",
								url: fetchedPokemon.sprites?.backDefault ?? ""),
				SpriteReference(name: "Back Male Shiny",
								url: fetchedPokemon.sprites?.backShiny ?? ""),
				SpriteReference(name: "Back Female",
								url: fetchedPokemon.sprites?.backFemale ?? ""),
				SpriteReference(name: "Back Female Shiny",
								url: fetchedPokemon.sprites?.backShinyFemale ?? "")
			]
		} else {
			pokemonSprites = [
				SpriteReference(name: "Front",
								url: fetchedPokemon.sprites?.frontDefault ?? ""),
				SpriteReference(name: "Front Shiny",
								url: fetchedPokemon.sprites?.frontShiny ?? ""),
				SpriteReference(name: "Back",
								url: fetchedPokemon.sprites?.backDefault ?? ""),
				SpriteReference(name: "Back Shiny",
								url: fetchedPokemon.sprites?.backShiny ?? "")
			]
		}
		pokemonSprites.removeAll {
			$0.url.isEmpty
		}
	}
	
	@MainActor
	private func fetchStats(from fetchedPokemon: Pokemon) {
		if let stats = fetchedPokemon.stats,
		   stats.count == 6 {
			self.stats = stats.map {
				return (name: $0.stat?.name ?? "ERROR",
						value: $0.baseStat ?? 0)
			}
		}
	}
}
