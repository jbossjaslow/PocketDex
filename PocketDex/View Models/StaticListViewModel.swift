//
//  StaticListViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift

class StaticListViewModel<ResourceType: Requestable & ResourceLimit>: ObservableObject {
	@Published var resourceList: [NamedAPIResource<ResourceType>] = []
	@Published var isLoading: Bool = false
	@Published var searchText: String = ""
	
	var filteredResources: [NamedAPIResource<ResourceType>] {
		if !searchText.isEmpty {
			return resourceList.filter { $0.name.contains(searchText.lowercased()) }
		} else {
			return resourceList
		}
	}
	
	func reset() {
		resourceList.removeAll()
	}
	
	func populateResourceList() async {
		isLoading = true
		
		do {
			let pagedList: PagedList<ResourceType> = try await ResourceType.requestStaticList(resourceLimit: ResourceType.normalLimit)
			self.resourceList.append(contentsOf: pagedList.results)
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
		
		isLoading = false
	}
}
