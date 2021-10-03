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
	
	init?(name: String? = nil) {
		switch name {
			case "level-up":
				self = .levelUp
			case "tutor":
				self = .tutor
			case "machine":
				self = .machine
			default:
				print("Move method: " + (name ?? "not found"))
				return nil
		}
	}
}
