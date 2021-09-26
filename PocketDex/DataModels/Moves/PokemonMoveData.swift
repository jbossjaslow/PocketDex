//
//  PokemonMoveData.swift
//  PokemonMoveData
//
//  Created by Josh Jaslow on 9/19/21.
//

import PokeSwift

struct PokemonMoveData {
	let moveName: String
	let moveURL: String
	let learnMethod: MoveLearnMethodType
	let minLevel: Int
	
	init?(move: PokemonMove) {
		guard let moveName = move.move?.name,
			  let moveURL = move.move?.url,
			  let learnMethod = MoveLearnMethodType(name: move.versionGroupDetails?.first(where: { $0.versionGroup?.name == VersionGroupName.Gen7.USUM })?.moveLearnMethod?.name),
			  let minLevel = move.versionGroupDetails?.first(where: { $0.versionGroup?.name == VersionGroupName.Gen7.USUM })?.levelLearnedAt else {
				  return nil
			  }
		self.moveName = moveName
		self.moveURL = moveURL
		self.learnMethod = learnMethod
		self.minLevel = minLevel
	}
}
