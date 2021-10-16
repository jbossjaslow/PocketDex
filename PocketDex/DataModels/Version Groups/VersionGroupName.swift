//
//  VersionGroupName.swift
//  VersionGroupName
//
//  Created by Josh Jaslow on 9/19/21.
//

import Foundation

struct VersionGroupName {
	struct Gen1 {
		static let redBlue = "red-blue"
		static let yellow = "yellow"
	}
	
	struct Gen2 {
		static let GS = "gold-silver"
		static let crystal = "crystal"
	}
	
	struct Gen3 {
		static let RS = "ruby-sapphire"
		static let emerald = "emerald"
		static let FRLG = "firered-leafgreen"
	}
	
	struct Gen4 {
		static let DP = "diamond-pearl"
		static let platinum = "platinum"
		static let HGSS = "heartgold=soulsilver"
	}
	
	struct Gen5 {
		static let BW = "black-white"
		static let B2W2 = "black-2-white-2"
	}
	
	struct Gen6 {
		static let XY = "x-y"
		static let ORAS = "omega-ruby-alpha-sapphire"
	}
	
	struct Gen7 {
		static let SM = "sun-moon"
		static let USUM = "ultra-sun-ultra-moon"
	}
	
	static let all = [
		Gen1.redBlue,
		Gen1.yellow,
		Gen2.GS,
		Gen2.crystal,
		Gen3.RS,
		Gen3.emerald,
		Gen3.FRLG,
		Gen4.DP,
		Gen4.platinum,
		Gen4.HGSS,
		Gen5.BW,
		Gen5.B2W2,
		Gen6.XY,
		Gen6.ORAS,
		Gen7.SM,
		Gen7.USUM
	]
}
