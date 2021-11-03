//
//  SpeciesVariety.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/2/21.
//

import PokeSwift

struct SpeciesVariety {
	/// Whether this variety is the default variety.
	let isDefault: Bool
	/// The Pokemon variety.
	let pokemon: NamedAPIResource<Pokemon>
}
