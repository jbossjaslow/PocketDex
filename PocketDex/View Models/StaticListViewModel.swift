//
//  StaticListViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift
import Collections

enum PokemonOrdering: String {
	case alphabetical = "A to Z"
	case `default` = "Default"
}

class StaticListViewModel<ResourceType: Requestable & ResourceLimit>: ObservableObject {
	@Published var resourceList: [NamedAPIResource<ResourceType>] = []
	@Published var isLoading: Bool = false
	@Published var searchText: String = ""
	@Published var ordering: PokemonOrdering = .default
	
	var arrangedResources: [NamedAPIResource<ResourceType>] {
		var resources = resourceList

		if !searchText.isEmpty {
			resources = resources.filter { $0.name.contains(searchText.lowercased()) }
		}

		if ordering == .alphabetical {
			resources.sort { $0.name < $1.name }
		}
//		switch ordering {
//			case .alphabetical:
//				resources.sort { $0.name < $1.name }
//			case .default:
//				print("No ordering needed")
//		}

		return resources
	}
	
	var alphabeticalResources: OrderedDictionary<String, [NamedAPIResource<ResourceType>]> {
		OrderedDictionary(grouping: arrangedResources,
						  by: { String($0.name.prefix(1)) })
	}
	
	func reset() {
		resourceList.removeAll()
	}
	
	@MainActor
	func populateResourceList() async {
		guard resourceList.isEmpty && !isLoading else {
			return
		}
		
		isLoading = true
		defer { isLoading = false }
		
		do {
			let pagedList: PagedList<ResourceType> = try await ResourceType.requestStaticList(resourceLimit: ResourceType.totalLimit)
			resourceList = pagedList.results
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}
