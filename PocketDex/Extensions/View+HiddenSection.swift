//
//  View+HiddenSection.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/9/21.
//

import SwiftUI

extension View {
	func displayAsHideableSection(title: String,
								  passThroughHeight: CGFloat,
								  titlePadding: CGFloat) -> some View {
		self.modifier(HideableSectionModifier(title: title,
											 passThroughHeight: passThroughHeight,
											 titlePadding: titlePadding))
	}
}
