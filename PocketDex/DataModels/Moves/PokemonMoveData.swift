//
//  PokemonMoveData.swift
//  PokemonMoveData
//
//  Created by Josh Jaslow on 9/19/21.
//

import Foundation
import PokeSwift

struct PokemonMoveData: Identifiable {
	let moveName: String
	let moveURL: String
	let learnMethod: MoveLearnMethodType
	let levelLearned: Int
	let version: VersionGroupName
	let id: UUID
	
	init?(moveName: String?,
		  moveURL: String?,
		  moveVersion: PokemonMoveVersion) {
		guard let moveName = moveName,
			  let moveURL = moveURL,
			  let learnMethod = MoveLearnMethodType(name: moveVersion.moveLearnMethod?.name),
			  let levelLearned = moveVersion.levelLearnedAt,
			  let name = moveVersion.versionGroup?.name,
			  let version = VersionGroupName(rawValue: name) else {
				  return nil
			  }
		
		self.learnMethod = learnMethod
		self.levelLearned = levelLearned
		self.version = version
		self.moveName = moveName
		self.moveURL = moveURL
		self.id = UUID()
	}
}

extension PokemonMove {
	func getAllMoveDataCombinations() -> [PokemonMoveData] {
		self.versionGroupDetails?.compactMap {
			PokemonMoveData(moveName: self.move?.name,
							moveURL: self.move?.url,
							moveVersion: $0)
		} ?? []
	}
}
