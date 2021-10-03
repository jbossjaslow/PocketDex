//
//  EvolutionChainPokemon.swift
//  EvolutionChainPokemon
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI
import PokeSwift

struct EvolutionChainPokemonCollection {
	var chainPokemon: [EvolutionChainPokemon] = []
	
	let startingSpecies: PokemonSpecies?
	
	init(from species: PokemonSpecies?) async {
		do {
			startingSpecies = species
			let evolutionChain = try await species?.evolutionChain?.request()
			try await buildEvolutionChainPokemon(from: evolutionChain?.chain)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	mutating func buildEvolutionChainPokemon(from chain: ChainLink?) async throws {
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

struct EvolutionChainPokemon {
	/// URL for front sprite
	var frontSprite: String?
	var species: PokemonSpecies?
	/// URL for `Pokemon` object associated with thie species
	var pokemonURL: String?
	
	init(from species: NamedAPIResource<PokemonSpecies>?) async {
		do {
			self.species = try await species?.request()
			if let varieties = self.species?.varieties,
			   let defaultPokemon = varieties.first(where: { $0.isDefault ?? false })?.pokemon {
				self.pokemonURL = defaultPokemon.url
				let pokemon = try await defaultPokemon.request()
				self.frontSprite = pokemon.sprites?.frontDefault
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
