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
		guard self != nil else {
			return nil
		}
		
		var map: TypeMap {
			switch name {
				case "normal":
					
				case "fighting":
					
				case "flying":
					
				case "poison":
					
				case "ground":
					
				case "rock":
					
				case "bug":
					
				case "ghost":
					
				case "steel":
					
				case "fire":
					
				case "water":
					
				case "grass":
					
				case "electric":
					
				case "psychic":
					
				case "ice":
					
				case "dragon":
					
				case "dark":
					
				case "fairy":
					
				default:
					return
			}
		}
		
		return map
	}
}

struct TypeMap {
	var color: Color
	var iconCircular: UIImage
	var iconRectangular: UIImage
}
