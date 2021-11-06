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
	@Published var displayName: String = "Pokemon"
	@Published var speciesInfo: SpeciesInfo
	@Published var pokemonTypes: [Type] = []
	@Published var backgroundGradient: [Color] = [.white]
	@Published var movesLearned: [PokemonMoveData] = []
	@Published var abilities: [PokemonAbility] = []
	@Published var stats: [PokemonStat] = []
	
	@Published var chainPokemonCollection: EvolutionChainPokemonCollection
	
	@Published var showingStats: Bool = false
	
	@Published var pokemonSprites: [SpriteReference] = [] // (Sprite name, url)
	@Published var variantSprites: [SpriteReference] = []
	
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
}

//MARK: - Load pokemon
extension PokemonViewModel {
	@MainActor
	func fetchPokemon() async {
		guard !makingRequest,
			  pokemonTypes.isEmpty else {
				  return
			  }
		
		makingRequest = true
		defer { makingRequest = false }
		
		do {
			let defaultPokemon = try await fetchSpecies(from: requestURL)
			
			await fetchEvolutions(from: requestURL)
			
			let fetchedPokemon = try await defaultPokemon.request()
			
			try await fetchTypes(from: fetchedPokemon)
			
			fetchMoves(from: fetchedPokemon)
			
			fetchAbilities(from: fetchedPokemon)
			
			fetchSprites(from: fetchedPokemon)
			
			try await fetchVariantSprites()
			
			fetchStats(from: fetchedPokemon)
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
	
	@MainActor
	@discardableResult
	/// Fetch the species and evolutions for the current pokemon
	private func fetchSpecies(from url: String) async throws -> NamedAPIResource<Pokemon> {
		let fetchedSpecies = try await PokemonSpecies.request(using: .url(url))
		self.speciesInfo = SpeciesInfo(from: fetchedSpecies)
		self.displayName = speciesInfo.name
		guard speciesInfo.varieties.count > 0 else {
			throw RequestErrors.noDefaultPokemonFound
		}
		return speciesInfo.varieties[0].pokemon
	}
	
	@MainActor
	private func fetchEvolutions(from speciesURL: String) async {
		self.chainPokemonCollection = await EvolutionChainPokemonCollection(from: speciesURL)
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
								spriteUrl: fetchedPokemon.sprites?.frontDefault ?? ""),
				SpriteReference(name: "Front Male Shiny",
								spriteUrl: fetchedPokemon.sprites?.frontShiny ?? ""),
				SpriteReference(name: "Front Female",
								spriteUrl: fetchedPokemon.sprites?.frontFemale ?? ""),
				SpriteReference(name: "Front Female Shiny",
								spriteUrl: fetchedPokemon.sprites?.frontShinyFemale ?? ""),
				SpriteReference(name: "Back Male",
								spriteUrl: fetchedPokemon.sprites?.backDefault ?? ""),
				SpriteReference(name: "Back Male Shiny",
								spriteUrl: fetchedPokemon.sprites?.backShiny ?? ""),
				SpriteReference(name: "Back Female",
								spriteUrl: fetchedPokemon.sprites?.backFemale ?? ""),
				SpriteReference(name: "Back Female Shiny",
								spriteUrl: fetchedPokemon.sprites?.backShinyFemale ?? "")
			]
		} else {
			pokemonSprites = [
				SpriteReference(name: "Front",
								spriteUrl: fetchedPokemon.sprites?.frontDefault ?? ""),
				SpriteReference(name: "Front Shiny",
								spriteUrl: fetchedPokemon.sprites?.frontShiny ?? ""),
				SpriteReference(name: "Back",
								spriteUrl: fetchedPokemon.sprites?.backDefault ?? ""),
				SpriteReference(name: "Back Shiny",
								spriteUrl: fetchedPokemon.sprites?.backShiny ?? "")
			]
		}
		pokemonSprites.removeAll {
			$0.spriteUrl.isEmpty
		}
	}
	
	@MainActor
	private func fetchVariantSprites() async throws {
		if speciesInfo.varieties.count > 1,
		   let defaultVariantSprite = try await speciesInfo.varieties[0].pokemon.request().sprites?.frontDefault {
			variantSprites = try await speciesInfo.varieties.parallelMap(parallelism: 4) {
				let fetchedVariant = try await $0.pokemon.request()
				return SpriteReference(name: fetchedVariant.name ?? "",
									   spriteUrl: fetchedVariant.sprites?.frontDefault ?? defaultVariantSprite,
									   pokemonUrl: $0.pokemon.url)
			}

			variantSprites.removeAll {
				$0.spriteUrl.isEmpty
			}
		} else {
			variantSprites.removeAll()
		}
	}
	
	@MainActor
	private func fetchStats(from fetchedPokemon: Pokemon) {
		if let stats = fetchedPokemon.stats,
		   stats.count == 6 {
			self.stats = stats.map {
				PokemonStat(statType: .init($0.stat?.name ?? "ERROR"),
							value: $0.baseStat ?? 0)
			}
		}
	}
}

// MARK: - Load evolution
extension PokemonViewModel {
	@MainActor
	/// Load an evolution into the current view
	/// - Parameters:
	///   - url: The url of the evolution's `PokemonSpecies` object
	///   - name: The name of the evolution
	func loadEvolution(url: String?,
					   name: String?) async {
		guard let url = url,
			  requestURL != url,
			  let name = name,
			  !makingRequest else {
				  return
			  }
		
		self.requestURL = url
		self.speciesInfo.name = name
		
		makingRequest = true
		defer { makingRequest = false }
		
		do {
			let defaultPokemon = try await fetchSpecies(from: requestURL)
			
			let fetchedPokemon = try await defaultPokemon.request()
			
			try await fetchTypes(from: fetchedPokemon)
			
			fetchMoves(from: fetchedPokemon)
			
			fetchAbilities(from: fetchedPokemon)
			
			fetchSprites(from: fetchedPokemon)
			
			try await fetchVariantSprites()
			
			fetchStats(from: fetchedPokemon)
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}

// MARK: - Load variant
extension PokemonViewModel {
	@MainActor
	/// Load a variant into the current view
	/// - Parameters:
	///   - url: The url of the variant's `Pokemon` object
	///   - name: The name of the variant
	func loadVariant(url: String?,
					 name: String?) async {
		guard let url = url,
			  requestURL != url,
			  let name = name,
			  !makingRequest else {
				  return
			  }
		
		self.requestURL = url
		self.speciesInfo.name = name
		
		makingRequest = true
		defer { makingRequest = false }
		
		do {
			let fetchedPokemon = try await Pokemon.request(using: .url(requestURL))
			
			if let speciesURL = fetchedPokemon.species?.url {
				try await fetchSpecies(from: speciesURL)
			}
			
			try await fetchTypes(from: fetchedPokemon)
			
			fetchMoves(from: fetchedPokemon)
			
			fetchAbilities(from: fetchedPokemon)
			
			fetchSprites(from: fetchedPokemon)
			
			fetchStats(from: fetchedPokemon)
			
			self.displayName = name
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}
