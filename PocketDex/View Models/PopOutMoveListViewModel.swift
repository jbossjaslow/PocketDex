//
//  PopOutMoveListViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/14/21.
//

import SwiftUI

class PopOutMoveListViewModel: ObservableObject {
	@Published var title: String
	@Binding var resources: [PokemonMoveData]
	@Published var searchText: String = ""
	
	@Published var selectedVersion: VersionGroupName = .redBlue
	@Published var ordering: MoveOrdering = .default
	
	var genSet: GenerationSet {
		return GenerationSet(gens: self.resources.map { $0.version })
	}
	private var filteredResourcesForVersion: [PokemonMoveData] {
		resources.filter {
			$0.version == selectedVersion
		}
	}
	private var filteredResourcesForMoveName: [PokemonMoveData] {
		if !searchText.isEmpty {
			return filteredResourcesForVersion.filter { $0.moveName.contains(searchText.lowercased()) }
		} else {
			return filteredResourcesForVersion
		}
	}
	var orderedFilteredResources: [PokemonMoveData] {
		switch ordering {
			case .alphabetical:
				return filteredResourcesForMoveName.sorted {
					$0.moveName < $1.moveName
				}
			case .default:
				return filteredResourcesForMoveName
			case .level:
				return filteredResourcesForMoveName.sorted {
					($0.levelLearned, $0.learnMethod.weight) <
						($1.levelLearned, $1.learnMethod.weight)
				}
			case .type:
				return filteredResourcesForMoveName.sorted {
					($0.learnMethod.weight, $0.moveName) <
						($1.learnMethod.weight, $1.moveName)
				}
		}
	}
	
	init(title: String,
		 resources: Binding<[PokemonMoveData]>) {
		self.title = title
		self._resources = resources
		self.selectedVersion = genSet.sortedSet.first ?? VersionGroupName.redBlue
	}
	
	func runOnAppear() {
		selectedVersion = genSet.sortedSet.first ?? .redBlue
	}
}
