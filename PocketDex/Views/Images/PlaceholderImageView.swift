//
//  PlaceholderImageView.swift
//  PlaceholderImageView
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

struct PlaceholderImageView: View {
	@State private var isRotating: Bool = false
	
    var body: some View {
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

struct testPlaceHolder: View {
	var body: some View {
		PlaceholderImageView()
	}
}

struct PlaceholderImageView_Previews: PreviewProvider {
    static var previews: some View {
        testPlaceHolder()
    }
}
