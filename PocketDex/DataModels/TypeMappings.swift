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
		switch name {
			case "normal":
				return TypeMap(color: Asset.PokemonType.Color.normal.color,
							   iconCircular: Asset.PokemonType.CircularIcons.normal.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.normal.image)
			case "fighting":
				return TypeMap(color: Asset.PokemonType.Color.fighting.color,
							   iconCircular: Asset.PokemonType.CircularIcons.fighting.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.fighting.image)
			case "flying":
				return TypeMap(color: Asset.PokemonType.Color.flying.color,
							   iconCircular: Asset.PokemonType.CircularIcons.flying.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.flying.image)
			case "poison":
				return TypeMap(color: Asset.PokemonType.Color.poison.color,
							   iconCircular: Asset.PokemonType.CircularIcons.poison.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.poison.image)
			case "ground":
				return TypeMap(color: Asset.PokemonType.Color.ground.color,
							   iconCircular: Asset.PokemonType.CircularIcons.ground.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.ground.image)
			case "rock":
				return TypeMap(color: Asset.PokemonType.Color.rock.color,
							   iconCircular: Asset.PokemonType.CircularIcons.rock.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.rock.image)
			case "bug":
				return TypeMap(color: Asset.PokemonType.Color.bug.color,
							   iconCircular: Asset.PokemonType.CircularIcons.bug.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.bug.image)
			case "ghost":
				return TypeMap(color: Asset.PokemonType.Color.ghost.color,
							   iconCircular: Asset.PokemonType.CircularIcons.ghost.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.ghost.image)
			case "steel":
				return TypeMap(color: Asset.PokemonType.Color.steel.color,
							   iconCircular: Asset.PokemonType.CircularIcons.steel.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.steel.image)
			case "fire":
				return TypeMap(color: Asset.PokemonType.Color.fire.color,
							   iconCircular: Asset.PokemonType.CircularIcons.fire.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.fire.image)
			case "water":
				return TypeMap(color: Asset.PokemonType.Color.water.color,
							   iconCircular: Asset.PokemonType.CircularIcons.water.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.water.image)
			case "grass":
				return TypeMap(color: Asset.PokemonType.Color.grass.color,
							   iconCircular: Asset.PokemonType.CircularIcons.grass.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.grass.image)
			case "electric":
				return TypeMap(color: Asset.PokemonType.Color.electric.color,
							   iconCircular: Asset.PokemonType.CircularIcons.electric.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.electric.image)
			case "psychic":
				return TypeMap(color: Asset.PokemonType.Color.psychic.color,
							   iconCircular: Asset.PokemonType.CircularIcons.psychic.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.psychic.image)
			case "ice":
				return TypeMap(color: Asset.PokemonType.Color.ice.color,
							   iconCircular: Asset.PokemonType.CircularIcons.ice.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.ice.image)
			case "dragon":
				return TypeMap(color: Asset.PokemonType.Color.dragon.color,
							   iconCircular: Asset.PokemonType.CircularIcons.dragon.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.dragon.image)
			case "dark":
				return TypeMap(color: Asset.PokemonType.Color.dark.color,
							   iconCircular: Asset.PokemonType.CircularIcons.dark.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.dark.image)
			case "fairy":
				return TypeMap(color: Asset.PokemonType.Color.fairy.color,
							   iconCircular: Asset.PokemonType.CircularIcons.fairy.image,
							   iconRectangular: Asset.PokemonType.RectangularIcons.fairy.image)
			default:
				return nil
		}
	}
}

struct TypeMap {
	var color: UIColor
	var iconCircular: UIImage
	var iconRectangular: UIImage
}
