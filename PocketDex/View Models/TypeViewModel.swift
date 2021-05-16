//
//  TypeViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/16/21.
//

import SwiftUI
import PokeSwift

class TypeViewModel: ObservableObject {
	@Published var typeMap: TypeMap? = TypeMap(color: Asset.PokemonType.Color.normal.color,
									  iconCircular: Asset.PokemonType.Icons.normalCircular.image,
									  iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
									  name: "normal")
	@Published var pokemonType: Type?
	
	@Published var makingRequest: Bool = false
	
	init(typeName: String) {
		makingRequest = true
		DispatchQueue.main.async {
			Type.request(using: .name(typeName)) { (_ result: Type?) in
				if let result = result {
					self.pokemonType = result
					self.typeMap = result.mapAdditionalInfo()
				}
				self.makingRequest = false
			}
		}
	}
	
	convenience init(typeMap: TypeMap) {
		self.init(typeName: typeMap.name)
	}
	
	init(type: Type) {
		pokemonType = type
		typeMap = type.mapAdditionalInfo()
	}
}

//	let types = ["normal",
//				 "fighting",
//				 "flying",
//				 "poison",
//				 "ground",
//				 "rock",
//				 "bug",
//				 "ghost",
//				 "steel",
//				 "fire",
//				 "water",
//				 "grass",
//				 "electric",
//				 "psychic",
//				 "ice",
//				 "dragon",
//				 "dark",
//				 "fairy"]
