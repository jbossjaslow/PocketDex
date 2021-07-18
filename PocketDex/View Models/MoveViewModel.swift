//
//  MoveViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/27/21.
//

import SwiftUI
import PokeSwift

class MoveViewModel: ObservableObject {
	@Published var move: Move? = nil
	@Published var type: Type? = nil
	@Published var learnedByPokemon: [NamedAPIResource<Pokemon>] = []
	
	var moveNameCapitalized: String {
		move?.name?.capitalizingFirstLetter() ?? "ERROR: No move name"
	}
	
	var moveEffectEnglish: String {
		guard let entries = move?.effectEntries,
			var englishEffect = entries.first(where: { $0.language?.name ?? "" == "en" })?.shortEffect else {
			return ""
		}
		
		if let effectChance = move?.effectChance {
			englishEffect = englishEffect.replacingOccurrences(of: "$effect_chance", with: "\(effectChance)")
		}
		return englishEffect
	}
	
	var typeMap: TypeMap? {
		type?.mapAdditionalInfo()
	}
	
	private var moveName: String
	
	init(moveName: String) {
		self.moveName = moveName
	}
	
	func fetchMove() async {
		do {
			let fetchedMove = try await Move.request(using: .name(moveName))
			self.move = fetchedMove
			self.type = try await fetchedMove.type?.request()
			self.learnedByPokemon = fetchedMove.learnedByPokemon ?? []
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}