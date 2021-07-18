//
//  AbilityViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 7/17/21.
//

import SwiftUI
import PokeSwift

class AbilityViewModel: ObservableObject {
	@Published var ability: Ability? = nil
	@Published var pokemonWithThisAbility: [NamedAPIResource<Pokemon>] = []
	
	var abilityNameCapitalized: String {
		ability?.name?.capitalizingFirstLetter() ?? "ERROR: No move name"
	}
	
	var abilityEffectEnglish: String {
		guard let entries = ability?.effectEntries,
			let englishEffect = entries.first(where: { $0.language?.name ?? "" == "en" })?.shortEffect else {
			return ""
		}
		
//		if let effectChance = ability?.effectChance {
//			englishEffect = englishEffect.replacingOccurrences(of: "$effect_chance", with: "\(effectChance)")
//		}
		return englishEffect
	}
	
	private var abilityName: String
	
	init(name: String) {
		self.abilityName = name
	}
	
	func fetchAbility() async {
		do {
			let fetchedAbility = try await Ability.request(using: .name(abilityName))
			self.ability = fetchedAbility
			pokemonWithThisAbility = fetchedAbility.pokemon?.compactMap {
				$0.pokemon
			} ?? []
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}
