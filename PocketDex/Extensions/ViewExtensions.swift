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
	@ViewBuilder
	func navigableTo<ToView: View>(disabled: Bool = false,
								   showTouchDown: Bool = true,
								   _ goingToView: @autoclosure () -> ToView) -> some View {
		switch (disabled, showTouchDown) {
			case (true, _):
				self
			case (_, true):
				NavigationLink(destination: goingToView) {
					self
				}
			case (_, false):
				self.modifier(NavigationModifier(goingToView: goingToView))
		}
	}
	
	@ViewBuilder
	func navButtonTo<ToView: View>(disabled: Bool = false,
								   _ goingToView: @autoclosure () -> ToView) -> some View {
		if !disabled {
			self
				.overlay {
					HStack {
						Spacer()
						
						VStack {
							NavigationLink(destination: goingToView) {
								Image(systemName: "circle.circle.fill")
							}
							
							Spacer()
						}
					}
				}
		} else {
			self
		}
	}
}
