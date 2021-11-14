//
//  CarouselView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/9/21.
//

import SwiftUI

struct CarouselView<Content: View, T: Identifiable & Equatable>: View {
	@Binding var items: [T]
	
	@State private var selectedItemScale: ScaleSize
	@State private var currentIndex: Int = 0
	@State private var currentOffset: CGFloat = 0
	@State private var offset: CGFloat = 0
	@State private var containerSize: CGSize = .zero
	@State private var snapThreshold: CGFloat = 50
	
	private let spacing: CGFloat
	private let showingScrollArrows: Bool
	@Binding private var indexToScrollTo: Int?
	private let alwaysStartAtBeginning: Bool
	
	let content: (T, Bool) -> Content
	
	private let generator = UISelectionFeedbackGenerator()
	
	init(_ items: Binding<[T]>,
		 selectedItemScale: ScaleSize,
		 spacing: CGFloat = 30,
		 showingScrollArrows: Bool = true,
		 alwaysStartAtBeginning: Bool = false,
		 indexToScrollTo: Binding<Int?> = .constant(nil),
		 @ViewBuilder content: @escaping (T, Bool) -> Content) {
		self._items = items
		self.alwaysStartAtBeginning = alwaysStartAtBeginning
		self._indexToScrollTo = indexToScrollTo
		self.spacing = spacing
		self.showingScrollArrows = showingScrollArrows
		self.content = content
		self.selectedItemScale = selectedItemScale
	}
	
	var body: some View {
		GeometryReader { geo in
			HStack(spacing: spacing) {
				ForEach(items) { item in
					content(item,
							itemIsSelected(item))
						.frame(width: geo.size.height,
							   height: geo.size.height)
						.scaledToFill()
						.scaleEffect(getScale(for: item))
				}
			}
			.frame(width: geo.size.width,
				   height: geo.size.height,
				   alignment: .leading)
			.onAppear {
				runOnAppear(geo: geo)
			}
			.position(x: geo.size.width - (geo.size.height / 2),
					  y: geo.size.height / 2)
			.offset(x: offset + currentOffset)
			.animation(.interactiveSpring(),
					   value: currentOffset)
			.animation(.easeOut,
					   value: offset)
			.gesture(dragGesture)
			.overlay(buttonOverlay)
			.onChange(of: indexToScrollTo) { _ in
				scrollToIndex()
			}
			.onChange(of: items) { _ in
				if alwaysStartAtBeginning {
					scrollToBeginning()
				}
			}
		}
	}
	
	private var buttonOverlay: some View {
		HStack {
			if showingScrollArrows,
			   !indexAtBeginning {
				Button {
					scroll(to: .left)
				} label: {
					Image(systemName: "arrow.left.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 50)
						.foregroundColor(.black.opacity(0.5))
				}
			}
			
			Spacer()
			
			if showingScrollArrows,
			   !indexAtEnd {
				Button {
					scroll(to: .right)
				} label: {
					Image(systemName: "arrow.right.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 50)
						.foregroundColor(.black.opacity(0.5))
				}
			}
		}
			.padding(.horizontal)
	}
	
	private var dragGesture: some Gesture {
		DragGesture(minimumDistance: 5)
			.onChanged {
				calculateOnChanged(distance: $0.translation.width)
			}
			.onEnded { _ in
				calculateDirectionToScroll()
			}
	}
}

//MARK: - "ViewModel" variables
extension CarouselView {
	private enum ScrollDirection: CGFloat {
		case left = -1
		case right = 1
	}
	
	enum ScaleSize: CGFloat {
		case unchanged = 0
		case small = 0.5
		case medium = 1
		case large = 2
	}
	
	private var indexAtBeginning: Bool {
		currentIndex == 0
	}
	
	private var indexAtEnd: Bool {
		currentIndex == items.count - 1
	}
	
	private var lowerDragBound: CGFloat {
		-snapThreshold - spacing / 2
	}
	
	private var upperDragBound: CGFloat {
		snapThreshold + spacing / 2
	}
}

//MARK: - "ViewModel" functions
extension CarouselView {
	private func itemIsSelected(_ item: T) -> Bool {
		guard items.contains(item),
			  currentIndex < items.count else {
			print("ERROR: array does not contain \(item)")
			return false
		}
		
		return items[currentIndex] == item
	}
	
	private func calculateOnChanged(distance: CGFloat) {
		currentOffset = (lowerDragBound...upperDragBound).clamp(value: distance) + distance * 0.1
	}
	
	private func calculateDirectionToScroll() {
		guard !items.isEmpty else {
			return
		}
		
		if abs(currentOffset) >= snapThreshold {
			var direction: ScrollDirection
			if currentOffset < 0 {
				guard !indexAtEnd else {
					currentOffset = 0
					return
				}
				
				direction = .right
			} else if currentOffset > 0 {
				guard !indexAtBeginning else {
					currentOffset = 0
					return
				}
				
				direction = .left
			} else {
				currentOffset = 0
				return
			}
			
			scroll(to: direction)
		}
		
		currentOffset = 0
	}
	
	private func scroll(to direction: ScrollDirection) {
		switch direction {
			case .right:
				currentIndex += 1
				offset -= (containerSize.height + spacing)
			case .left:
				currentIndex -= 1
				offset += (containerSize.height + spacing)
		}
		
		generator.selectionChanged()
	}
	
	private func getScale(for item: T) -> CGFloat {
		guard itemIsSelected(item),
			  selectedItemScale != .unchanged,
			  containerSize.height > 0 else {
				  return 1
			  }
		
		let spacingFactor = spacing * selectedItemScale.rawValue
		return 1 + (spacingFactor / containerSize.height)
	}
	
	private func runOnAppear(geo: GeometryProxy) {
		self.containerSize = geo.size
		self.snapThreshold = geo.size.height / 2
		
		scrollToIndex()
	}
	
	func scrollToIndex() {
		guard let index = indexToScrollTo,
			  index < items.count,
			  index >= 0,
			  self.items.count > 1 else {
				  return
			  }
		
		offset = -(containerSize.height + spacing) * CGFloat(index)
		currentIndex = index
	}
	
	func scrollToBeginning() {
		offset = 0
		currentIndex = 0
	}
}
