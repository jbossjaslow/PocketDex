//
//  GenerationalResource.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/2/21.
//

import PokeSwift

struct GenerationalResource<ResourceType: Requestable & ResourceLimit> {
	let resource: NamedAPIResource<ResourceType>
	let generation: Int
}

extension String {
	var speciesId: Int {
		guard self.contains("pokemon-species"),
			  let id = self.split(separator: "/").last,
			  let intId = Int(id) else {
			return -1
		}
		
		return intId
	}
}
