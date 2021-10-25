//
//  SectionIndexModifier.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/24/21.
//

import SwiftUI

struct SectionIndexModifier: ViewModifier {
	@GestureState private var dragLocation: CGPoint = .zero
	
	private let arr: [String]
	private let hidden: Bool
	private let proxy: ScrollViewProxy
	private let generator = UISelectionFeedbackGenerator()
	
	@State private var selectedTitle: String? = nil
	
	init(from arr: [String],
		 hidden: Bool,
		 proxy: ScrollViewProxy) {
		self.arr = arr
		self.hidden = hidden
		self.proxy = proxy
	}
	
	func body(content: Content) -> some View {
		HStack {
			content
			
			if !hidden {
				VStack {
					ForEach(arr, id: \.self) { sectionIndex in
						Text(sectionIndex)
							.font(.system(size: 16))
							.foregroundColor(.blue)
							.background(dragObserver(title: sectionIndex))
					}
				}
				.animation(.linear(duration: 0.5),
							value: hidden)
				.gesture(dragGesture)
			}
		}
	}
	
	private var dragGesture: some Gesture {
		DragGesture(minimumDistance: 0,
					coordinateSpace: .global)
			.updating($dragLocation) { value, state, _ in
				state = value.location
			}
	}
	
	private func dragObserver(title: String) -> some View {
		GeometryReader { geometry in
			dragObserver(geometry: geometry, title: title)
		}
	}
	
	private func dragObserver(geometry: GeometryProxy,
							  title: String) -> some View {
		if geometry.frame(in: .global).contains(dragLocation) {
			changeSelection(title: title)
		}
		return Rectangle()
			.fill(Color.clear)
	}
	
	private func changeSelection(title: String) {
		if selectedTitle == nil || title != selectedTitle {
			DispatchQueue.main.async {
				proxy.scrollTo(title,
							   anchor: .center)
				generator.selectionChanged()
				self.selectedTitle = title
			}
		}
	}
}
