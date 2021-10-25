//
//  List+SectionIndex.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/24/21.
//

import SwiftUI

extension View {
	func sectionIndices(from arr: [String],
						hidden: Bool,
						proxy: ScrollViewProxy) -> some View {
		self.modifier(SectionIndexModifier(from: arr,
										   hidden: hidden,
										   proxy: proxy))
	}
}
