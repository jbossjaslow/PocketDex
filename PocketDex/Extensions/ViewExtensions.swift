//
//  ViewExtensions.swift
//  ViewExtensions
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI

// MARK: - If()
extension View {
	@ViewBuilder
	func `if`<Transform: View>(_ condition: Bool,
							   transform: (Self) -> Transform) -> some View {
		if condition {
			transform(self)
		}
		else {
			self
		}
	}
}

// MARK: - Navigation
extension View {
	func navigableTo<ToView: View>(disabled: Bool = false,
								   _ goingToView: @autoclosure () -> ToView) -> some View {
		NavigationLink(destination: goingToView) {
			self
		}
		.disabled(disabled)
//		self.modifier(NavigationModifier(disabled: disabled,
//										 goingToView: goingToView))
	}
}
