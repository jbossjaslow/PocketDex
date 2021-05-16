//
//  StringEntensions.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/15/21.
//

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}

	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
}
