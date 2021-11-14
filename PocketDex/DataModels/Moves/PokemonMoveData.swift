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
//	let learnMethod: MoveLearnMethodType
//	let minLevel: Int
//	let generation: String
	let id: UUID
	
//	let learnInfo: MoveLearnInfo
	let learnInfoArr: [MoveLearnInfo]
	
	init?(move: PokemonMove) {
//		  gen: String) {
//		self.generation = gen
		
		guard let moveName = move.move?.name,
			  let moveURL = move.move?.url,
			  let versionGroupDetails = move.versionGroupDetails else {
//			  let minMoveVersion = move.getMinimumVersion(generation),
//			  let learnMethod = MoveLearnMethodType(name: minMoveVersion.moveLearnMethod?.name),
//			  let minLevel = minMoveVersion.levelLearnedAt else {
				  return nil
			  }
		
		self.moveName = moveName
		self.moveURL = moveURL
		learnInfoArr = versionGroupDetails.compactMap {
			MoveLearnInfo(from: $0)
		}
//		self.learnMethod = learnMethod
//		self.minLevel = minLevel
		self.id = UUID()
	}
	
//	func getAllVersions() -> Set<VersionGroupName> {
//		Set<VersionGroupName>(learnInfoArr.map { $0.version })
//	}
	
	func getAllVersions() -> [VersionGroupName] {
		learnInfoArr.map { $0.version }
	}
	
	func hasDataForVersion(_ version: VersionGroupName) -> Bool {
		learnInfoArr.contains {
			$0.version == version
		}
	}
}

struct MoveLearnInfo {
	let learnMethod: MoveLearnMethodType
	let levelLearned: Int
	let version: VersionGroupName
	
	init?(from version: PokemonMoveVersion) {
		guard let learnMethod = MoveLearnMethodType(name: version.moveLearnMethod?.name),
			  let levelLearned = version.levelLearnedAt,
			  let name = version.versionGroup?.name,
			  let version = VersionGroupName(rawValue: name) else {
				  return nil
			  }
		
		self.learnMethod = learnMethod
		self.levelLearned = levelLearned
		self.version = version
	}
}

//struct PMDDisplay {
//	let name: String
//	let learnMethod: MoveLearnMethodType
//	let levelLearned: Int
//
//
//}

//extension PokemonMove {
//	func getMinimumVersion(_ minGen: String) -> PokemonMoveVersion? {
//		self.versionGroupDetails?.first {
//			$0.versionGroup?.name == minGen
//		}
//	}
//}

//extension SortDescriptor {
//	static func learnMethod(_ moveData: PokemonMoveData) -> Self {
//		Self { move0, move1 in
//			guard move0 != move1 else {
//				return .orderedSame
//			}
//
//			return move0 < move1 ? .orderedAscending : .orderedDescending
//		}
//	}
//}
