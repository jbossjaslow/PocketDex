//
//  TypeMappings.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/8/21.
//

import PokeSwift
import SwiftUI

extension Type {
	func mapAdditionalInfo() -> TypeMap? {
		Type.mapAdditionalInfo(self.name ?? "")
	}
	
	static func mapAdditionalInfo(_ typeName: String) -> TypeMap? {
		switch typeName {
			case "normal":
				return TypeMap(color: Asset.PokemonType.Color.normal.color,
							   iconCircular: Asset.PokemonType.Icons.normalCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
							   name: typeName)
			case "fighting":
				return TypeMap(color: Asset.PokemonType.Color.fighting.color,
							   iconCircular: Asset.PokemonType.Icons.fightingCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.fightingRectangular.image,
							   name: typeName)
			case "flying":
				return TypeMap(color: Asset.PokemonType.Color.flying.color,
							   iconCircular: Asset.PokemonType.Icons.flyingCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.flyingRectangular.image,
							   name: typeName)
			case "poison":
				return TypeMap(color: Asset.PokemonType.Color.poison.color,
							   iconCircular: Asset.PokemonType.Icons.poisonCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.poisonRectangular.image,
							   name: typeName)
			case "ground":
				return TypeMap(color: Asset.PokemonType.Color.ground.color,
							   iconCircular: Asset.PokemonType.Icons.groundCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.groundRectangular.image,
							   name: typeName)
			case "rock":
				return TypeMap(color: Asset.PokemonType.Color.rock.color,
							   iconCircular: Asset.PokemonType.Icons.rockCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.rockRectangular.image,
							   name: typeName)
			case "bug":
				return TypeMap(color: Asset.PokemonType.Color.bug.color,
							   iconCircular: Asset.PokemonType.Icons.bugCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.bugRectangular.image,
							   name: typeName)
			case "ghost":
				return TypeMap(color: Asset.PokemonType.Color.ghost.color,
							   iconCircular: Asset.PokemonType.Icons.ghostCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.ghostRectangular.image,
							   name: typeName)
			case "steel":
				return TypeMap(color: Asset.PokemonType.Color.steel.color,
							   iconCircular: Asset.PokemonType.Icons.steelCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.steelRectangular.image,
							   name: typeName)
			case "fire":
				return TypeMap(color: Asset.PokemonType.Color.fire.color,
							   iconCircular: Asset.PokemonType.Icons.fireCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.fireRectangular.image,
							   name: typeName)
			case "water":
				return TypeMap(color: Asset.PokemonType.Color.water.color,
							   iconCircular: Asset.PokemonType.Icons.waterCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.waterRectangular.image,
							   name: typeName)
			case "grass":
				return TypeMap(color: Asset.PokemonType.Color.grass.color,
							   iconCircular: Asset.PokemonType.Icons.grassCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.grassRectangular.image,
							   name: typeName)
			case "electric":
				return TypeMap(color: Asset.PokemonType.Color.electric.color,
							   iconCircular: Asset.PokemonType.Icons.electricCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.electricRectangular.image,
							   name: typeName)
			case "psychic":
				return TypeMap(color: Asset.PokemonType.Color.psychic.color,
							   iconCircular: Asset.PokemonType.Icons.psychicCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.psychicRectangular.image,
							   name: typeName)
			case "ice":
				return TypeMap(color: Asset.PokemonType.Color.ice.color,
							   iconCircular: Asset.PokemonType.Icons.iceCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.iceRectangular.image,
							   name: typeName)
			case "dragon":
				return TypeMap(color: Asset.PokemonType.Color.dragon.color,
							   iconCircular: Asset.PokemonType.Icons.dragonCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.dragonRectangular.image,
							   name: typeName)
			case "dark":
				return TypeMap(color: Asset.PokemonType.Color.dark.color,
							   iconCircular: Asset.PokemonType.Icons.darkCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.darkRectangular.image,
							   name: typeName)
			case "fairy":
				return TypeMap(color: Asset.PokemonType.Color.fairy.color,
							   iconCircular: Asset.PokemonType.Icons.fairyCircular.image,
							   iconRectangular: Asset.PokemonType.Icons.fairyRectangular.image,
							   name: typeName)
			default:
				return nil
		}
	}
}

struct TypeMap: Identifiable {
	var id = UUID()
	
	var color: UIColor
	var iconCircular: UIImage
	var iconRectangular: UIImage
	var name: String
}

extension Array where Element: Type {
	var mappings: [TypeMap] {
		self.compactMap {
			$0.mapAdditionalInfo()
		}
	}
}
