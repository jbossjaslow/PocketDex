//
//  LoadingView.swift
//  LoadingView
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

struct LoadingView: View {
	@Environment(\.colorScheme) private var colorScheme
	@State private var isRotating: Bool = false
	
	let fillEntireBackground: Bool
	
	private var backgroundColor: Color {
		if colorScheme == .dark {
			return .black
		} else {
			return .white
		}
	}
	
	init(fillEntireBackground: Bool = false) {
		self.fillEntireBackground = fillEntireBackground
	}
	
    var body: some View {
		ZStack {
			if fillEntireBackground {
				backgroundColor
					.edgesIgnoringSafeArea(.all)
			}
			
			Image(uiImage: Asset.Pokeball.pokeball.image)
				.resizable()
				.scaledToFit()
				.frame(width: 200,
					   height: 200)
				.scaleEffect(0.25)
				.rotationEffect(.degrees(isRotating ? 360 : 0))
				.onAppear {
					withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
						isRotating = true
					}
				}
				.onDisappear {
					isRotating = false
				}
		}
    }
}

struct testPlaceHolder: View {
	var body: some View {
		LoadingView()
	}
}

struct PlaceholderImageView_Previews: PreviewProvider {
    static var previews: some View {
        testPlaceHolder()
    }
}
