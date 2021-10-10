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
		let minGen = VersionGroupName.Gen7.USUM
		
		guard let moveName = move.move?.name,
			  let moveURL = move.move?.url,
			  let moveVersion = move.getVersion(minGen),
			  let learnMethod = MoveLearnMethodType(name: moveVersion.moveLearnMethod?.name),
			  let minLevel = moveVersion.levelLearnedAt else {
				  return nil
			  }
		
		self.moveName = moveName
		self.moveURL = moveURL
		self.learnMethod = learnMethod
		self.minLevel = minLevel
	}
}

extension PokemonMove {
	func getVersion(_ minGen: String) -> PokemonMoveVersion? {
		self.versionGroupDetails?.first {
			$0.versionGroup?.name == minGen
		}
	}
}