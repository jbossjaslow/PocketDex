//
//  NavigationModifier.swift
//  NavigationModifier
//
//  Created by Josh Jaslow on 9/5/21.
//

import SwiftUI

struct NavigationModifier<ToView: View>: ViewModifier {
	var goingToView: () -> ToView
	var disabled: Bool
	
	init(disabled: Bool = false,
		 goingToView: @escaping () -> ToView) {
		self.goingToView = goingToView
		self.disabled = disabled
	}
	
	func body(content: Content) -> some View {
		NavigationLink(destination: goingToView) {
			content
		}
		.disabled(disabled)
	}
}
