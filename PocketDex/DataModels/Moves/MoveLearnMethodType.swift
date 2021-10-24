//
//  MoveLearnMethodType.swift
//  MoveLearnMethodType
//
//  Created by Josh Jaslow on 9/19/21.
//

import PokeSwift

enum MoveLearnMethodType: String {
	case levelUp = "Level Up"
	case machine = "TM/HM"
	case tutor = "Move Tutor"
	case egg = "Egg"
	
	var weight: Int {
		switch self {
			case .levelUp:
				return 0
			case .machine:
				return 1
			case .tutor:
				return 2
			case .egg:
				return 3
		}
	}
	
	init?(name: String? = nil) {
		switch name {
			case "level-up":
				self = .levelUp
			case "tutor":
				self = .tutor
			case "machine":
				self = .machine
			case "egg":
				self = .egg
			default:
				print("Move method: " + (name ?? "not found"))
				return nil
		}
	}
}
