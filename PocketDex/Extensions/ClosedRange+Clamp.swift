//
//  ClosedRange+Clamp.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/9/21.
//

import Foundation

extension ClosedRange {
	func clamp(value: Bound) -> Bound {
		return self.lowerBound > value ? self.lowerBound
			: self.upperBound < value ? self.upperBound
			: value
	}
}
