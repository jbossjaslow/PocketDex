//
//  EvolutionChainPokemon.swift
//  EvolutionChainPokemon
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI
import PokeSwift

class EvolutionChainPokemonCollection: ObservableObject {
	@Published var chainPokemon: [EvolutionChainPokemon] = []
	
	private let speciesURL: String
	
	@Published var currentPokemonIndex: Int? = nil
	
	init() {
		speciesURL = ""
	}
	
	@MainActor
	init(from speciesURL: String) async {
		self.speciesURL = speciesURL
		do {
			let fetchedSpecies = try await PokemonSpecies.request(using: .url(self.speciesURL))
			let evolutionChain = try await fetchedSpecies.evolutionChain?.request()
			try await buildEvolutionChainPokemon(from: evolutionChain?.chain)
			currentPokemonIndex = chainPokemon.firstIndex {
				$0.pokemonSpeciesURL == self.speciesURL
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	@MainActor
	func buildEvolutionChainPokemon(from chain: ChainLink?) async throws {
		if let currSpecies = chain?.species {
			chainPokemon.append(await EvolutionChainPokemon(from: currSpecies))
		}
		
		if let evolvesTo = chain?.evolvesTo,
		   !evolvesTo.isEmpty {
			for pokemon in evolvesTo {
				// one pokemon may evolve into more than one pokemon - ex: Kirlia into Gardevoir & Gallade
				try await buildEvolutionChainPokemon(from: pokemon)
			}
		}
	}
}

struct EvolutionChainPokemon: Identifiable, Equatable {
	/// URL for front sprite
	var frontSprite: String?
	/// Species
	var species: PokemonSpecies?
	/// URL for `PokemonSpecies` object associated with thie species
	var pokemonSpeciesURL: String?
	
	let id: UUID
	
	@MainActor
	init(from species: NamedAPIResource<PokemonSpecies>?) async {
		do {
			self.species = try await species?.request()
			self.pokemonSpeciesURL = species?.url
			if let varieties = self.species?.varieties,
			   let defaultPokemon = varieties.first(where: { $0.isDefault ?? false })?.pokemon {
				let pokemon = try await defaultPokemon.request()
				self.frontSprite = pokemon.sprites?.frontDefault
			}
		} catch {
			print(error.localizedDescription)
		}
		self.id = UUID()
	}
	
	static func == (lhs: EvolutionChainPokemon,
					rhs: EvolutionChainPokemon) -> Bool {
		return lhs.id == rhs.id
	}
}
