//
//  HiddenSectionModifier.swift
//  PocketDex
//
//  Created by Josh Jaslow on 11/9/21.
//

import SwiftUI

struct HideableSectionModifier: ViewModifier {
	@State private var showingSection: Bool = false
	private let title: String
	private let passThroughHeight: CGFloat
	private let titlePadding: CGFloat
	private let springAnimation = Animation.spring(response: 0.3,
													dampingFraction: 0.5,
													blendDuration: 0.1)
	
	init(title: String,
		 passThroughHeight: CGFloat,
		 titlePadding: CGFloat) {
		self.title = title
		self.passThroughHeight = passThroughHeight
		self.titlePadding = titlePadding
	}
	
	func body(content: Content) -> some View {
		VStack {
			HStack {
				Text(title)
					.font(.title)
					.bold()
				
				Spacer()
				
				Button {
					showingSection.toggle()
				} label: {
					Image(systemName: "chevron.right.circle")
						.resizable()
						.scaledToFit()
						.frame(height: 30)
						.foregroundColor(.black)
						.rotationEffect(Angle(degrees: showingSection ? 90 : 0))
				}
			}
			.padding(.horizontal,
					 titlePadding)
			.animation(springAnimation,
					   value: showingSection)
			
			if showingSection {
				content
					.frame(height: passThroughHeight)
					.animation(springAnimation,
							   value: showingSection)
			}
		}
	}
}
