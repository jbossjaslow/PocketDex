//
//  StaticListViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift

enum Ordering: String {
	case alphabetical = "A to Z"
	case `default` = "Default"
}

class StaticListViewModel<ResourceType: Requestable & ResourceLimit>: ObservableObject {
	@Published var resourceList: [NamedAPIResource<ResourceType>] = []
	@Published var isLoading: Bool = false
	@Published var searchText: String = ""
	@Published var ordering: Ordering = .default
	
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
	
	func reset() {
		resourceList.removeAll()
	}
	
	func populateResourceList() async {
		guard resourceList.isEmpty && !isLoading else {
			return
		}
		
		isLoading = true
		
		do {
			let pagedList: PagedList<ResourceType> = try await ResourceType.requestStaticList(resourceLimit: ResourceType.normalLimit)
			resourceList = pagedList.results
			isLoading = false
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}
