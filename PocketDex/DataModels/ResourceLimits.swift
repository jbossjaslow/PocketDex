//
//  ResourceLimits.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import PokeSwift

protocol ResourceLimit {
	static var normalLimit: Int { get }
	static var totalLimit: Int { get }
}

extension Pokemon: ResourceLimit {
	static var normalLimit = 898
	static var totalLimit = 1118
}

extension Ability: ResourceLimit {
	/// Abilities from 268-327 have the tag `is_main_series: false`
	static var normalLimit = 267
	static var totalLimit = 327
}

extension Type: ResourceLimit {
	static var normalLimit = 18
	static var totalLimit = 20
}

extension Move: ResourceLimit {
	static var normalLimit = 826
	static var totalLimit = 844
}
