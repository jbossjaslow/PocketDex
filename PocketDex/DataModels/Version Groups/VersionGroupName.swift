//
//  VersionGroupName.swift
//  VersionGroupName
//
//  Created by Josh Jaslow on 9/19/21.
//

import Foundation

enum VersionGroupName: String, CaseIterable {
	// gen 1
	case redBlue = "red-blue"
	case yellow = "yellow"
	
	// gen 2
	case GS = "gold-silver"
	case crystal = "crystal"
	
	// gen 3
	case RS = "ruby-sapphire"
	case emerald = "emerald"
	case FRLG = "firered-leafgreen"
	
	// gen 4
	case DP = "diamond-pearl"
	case platinum = "platinum"
	case HGSS = "heartgold=soulsilver"
	
	// gen 5
	case BW = "black-white"
	case B2W2 = "black-2-white-2"
	
	// gen 6
	case XY = "x-y"
	case ORAS = "omega-ruby-alpha-sapphire"
	
	// gen 7
	case SM = "sun-moon"
	case USUM = "ultra-sun-ultra-moon"
	
	var genWeight: Float {
		switch self {
			case .redBlue:
				return 1.1
			case .yellow:
				return 1.2
			case .GS:
				return 2.1
			case .crystal:
				return 2.2
			case .RS:
				return 3.1
			case .emerald:
				return 3.2
			case .FRLG:
				return 3.3
			case .DP:
				return 4.1
			case .platinum:
				return 4.2
			case .HGSS:
				return 4.3
			case .BW:
				return 5.1
			case .B2W2:
				return 5.2
			case .XY:
				return 6.1
			case .ORAS:
				return 6.2
			case .SM:
				return 7.1
			case .USUM:
				return 7.2
		}
	}
}

struct GenerationSet {
	private var genSet: Set<VersionGroupName> = Set()
	var sortedSet: [VersionGroupName] {
		genSet.sorted()
	}
	
	init(gens: [VersionGroupName]) {
		genSet = Set<VersionGroupName>(gens)
	}
}

extension VersionGroupName: Comparable {
	static func < (lhs: VersionGroupName,
				   rhs: VersionGroupName) -> Bool {
		lhs.genWeight < rhs.genWeight
	}
}
