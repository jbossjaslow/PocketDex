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
	
	init() {
		populateResourceList()
	}
	
	func reset() {
		resourceList.removeAll()
	}
	
	func populateResourceList() {
		isLoading = true
		ResourceType.requestList(resourceLimit: ResourceType.normalLimit) { (_ result: PagedList<ResourceType>?) in
			DispatchQueue.main.async {
				self.isLoading = false
				if let pagedList = result {
					self.resourceList.append(contentsOf: pagedList.results)
				}
			}
		}
	}
}
