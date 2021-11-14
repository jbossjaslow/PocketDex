//
//  MoveListOrderingEnum.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/14/21.
//

import Foundation

enum MoveOrdering: String, CaseIterable {
	case alphabetical = "A to Z"
	case `default` = "Default"
	case level = "Level learned at"
	case type = "Learn method"
}
