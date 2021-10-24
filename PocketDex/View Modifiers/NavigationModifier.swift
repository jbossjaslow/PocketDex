//
//  NavigationModifier.swift
//  NavigationModifier
//
//  Created by Josh Jaslow on 9/5/21.
//

import SwiftUI

struct NavigationModifier<ToView: View>: ViewModifier {
	@State private var goingToDestination: Bool = false
	private let goingToView: ToView
	
	init(@ViewBuilder goingToView: () -> ToView) {
		self.goingToView = goingToView()
	}
	
	func body(content: Content) -> some View {
		content
			.onTapGesture {
				goingToDestination = true
			}
			.background(
				NavigationLink(destination: goingToView,
							   isActive: $goingToDestination) {
					EmptyView()
				}
			)
	}
}
