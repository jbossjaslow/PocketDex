//
//  PokemonStat.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/6/21.
//

struct PokemonStat: Equatable {
	enum StatType: String {
		case hp = "HP"
		case atk = "ATK"
		case def = "DEF"
		case spa = "SPA"
		case spd = "SPD"
		case spe = "SPE"
		
		init(_ name: String) {
			switch name {
				case "hp":
					self = .hp
				case "attack":
					self = .atk
				case "defense":
					self = .def
				case "special-attack":
					self = .spa
				case "special-defense":
					self = .spd
				case "speed":
					self = .spe
				default:
					self = .hp
			}
		}
	}
	
	let statType: StatType
	let value: Int
}
