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
//	@Published var resourceList: [NamedAPIResource<ResourceType>] = []
	@Published var isLoading: Bool = false
	@Published var searchText: String = ""
	@Published var ordering: PokemonOrdering = .default
	@Published var selectedGen: String = "national"
	
//	@Published private var genSeparatedResources: OrderedDictionary<String, [NamedAPIResource<ResourceType>]> = [:]
	private var resourceList: [GenerationalResource<ResourceType>] = []
	
	var arrangedResources: [GenerationalResource<ResourceType>] {
		var resources = resourceList
		
		if selectedGen != "national" {
			resources = resources.filter { $0.generation.description == selectedGen }
		}
		
		if !searchText.isEmpty {
			resources = resources.filter {
				$0.resource.name.contains(searchText.lowercased()) ||
				$0.resource.url.speciesIdPadded.contains(searchText.lowercased())
			}
		}
		
		switch ordering {
			case .alphabetical:
				resources.sort { $0.resource.name < $1.resource.name }
			case .default:
				resources.sort {
					$0.resource.url.speciesId < $1.resource.url.speciesId
				}
		}

		return resources
	}
	
	var alphabeticalResources: OrderedDictionary<String, [GenerationalResource<ResourceType>]> {
		OrderedDictionary(grouping: arrangedResources,
						  by: { String($0.resource.name.prefix(1)) })
	}
	
	@MainActor
	func populateResourceList() async {
		guard !isLoading,
			  resourceList.isEmpty else {
			return
		}
		
		isLoading = true
		defer { isLoading = false }
		
		do {
//			let pagedList: PagedList<ResourceType> = try await ResourceType.requestStaticList(resourceLimit: ResourceType.totalLimit)
//			resourceList = pagedList.results
			
			for gen in 1...8 {
				let otherGeneration: Generation = try await Generation.request(using: .id(gen))
				
				var otherGenResourceList: [NamedAPIResource<ResourceType>]
				switch ResourceType.self {
					case is PokemonSpecies.Type:
						guard let speciesArr = otherGeneration.pokemonSpecies as? [NamedAPIResource<ResourceType>] else {
							continue
						}
						otherGenResourceList = speciesArr
					case is Move.Type:
						guard let movesArr = otherGeneration.moves as? [NamedAPIResource<ResourceType>] else {
							continue
						}
						otherGenResourceList = movesArr
					case is Ability.Type:
						guard let abilitiesArr = otherGeneration.abilities as? [NamedAPIResource<ResourceType>] else {
							continue
						}
						otherGenResourceList = abilitiesArr
					default:
						continue
				}
				
				let mappedResources = otherGenResourceList.map {
					GenerationalResource(resource: $0,
										 generation: gen)
				}
				resourceList.append(contentsOf: mappedResources)
			}
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}
