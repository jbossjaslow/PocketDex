//
//  SpeciesInfo.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/16/21.
//

import Foundation
import PokeSwift

struct SpeciesInfo {
	let baseHappiness: Int
	let captureRate: Int
//	let color:
//	let eggGroups:
//	let evolutionChain:
//	let flavorTextEntries: [VersionGroupName: String]
//	let formDescriptions: []
	let formsSwitchable: Bool
	let genderRate: Int
	let genus: String
//	let initialGeneration:
//	let growthRate:
//	let habitat:
	let hasGenderDifferences: Bool
	let hatchCounter: Int
	let id: Int
	let isBaby: Bool
	let isLegendary: Bool
	let isMythical: Bool
	var name: String
	let order: Int
//	let palParkEncounters:
//	let pokedexNumbers:
//	let shape:
//	let varieties:
	
	init(from species: PokemonSpecies) {
		self.baseHappiness = species.baseHappiness ?? 0
		self.captureRate = species.captureRate ?? 0
//		self.flavorTextEntries
		self.formsSwitchable = species.formsSwitchable ?? false
		self.genderRate = species.genderRate ?? 0
		self.hasGenderDifferences = species.hasGenderDifferences ?? false
		self.hatchCounter = species.hatchCounter ?? 0
		self.id = species.id ?? 0
		self.isBaby = species.isBaby ?? false
		self.isLegendary = species.isLegendary ?? false
		self.isMythical = species.isMythical ?? false
		self.name = species.name ?? ""
		self.order = species.order ?? 0
		
		if let genusList = species.genera {
			let genusEnglish = genusList.filter {
				$0.language?.name == "en"
			}
			self.genus = genusEnglish.first?.genus ?? "GENUS ERROR"
		} else {
			self.genus = "Unknown genus"
		}
	}
	
	init() {
		self.baseHappiness = 0
		self.captureRate = 0
		self.formsSwitchable = false
		self.genderRate = 0
		self.genus = ""
		self.hasGenderDifferences = false
		self.hatchCounter = 0
		self.id = 0
		self.isBaby = false
		self.isLegendary = false
		self.isMythical = false
		self.name = ""
		self.order = 0
	}
}
