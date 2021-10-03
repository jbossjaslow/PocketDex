//
//  RemoteImageView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/3/21.
//

import SwiftUI
import PokeSwift

struct RemoteImageView: View {
	@State private var image: UIImage?
	@State private var loading: Bool = false
	@Binding var url: String
	
	init(url: Binding<String>) {
		self._url = url
	}
	
    var body: some View {
		VStack {
			if let image = image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.loadingResource(isLoading: $loading)
			}
		}
		.onAppear {
			loadImage(from: url)
		}
		.onChange(of: url) { _ in
			loadImage(from: url)
		}
    }
	
	func loadImage(from url: String) {
//		loading = true
//
//		SessionManager.requestImage(url: url) { result in
//			DispatchQueue.main.async {
//				if case .success(let image) = result {
//					self.image = image
//				}
//				loading = false
//			}
//		}
	}
}

extension View {
	func loadingResource(isLoading: Binding<Bool>) -> some View {
		self.modifier(LoadingRotationImageModifer(isLoading: isLoading))
	}
}

struct LoadingRotationImageModifer: ViewModifier {
	@Binding var isLoading: Bool
	@State private var animating: Bool = false
	
	private var repeatForeverAnimation: Animation {
		Animation.linear(duration: 3.0)
			.repeatForever(autoreverses: false)
	}
	
	func body(content: Content) -> some View {
		content
//			.overlay(
//				HStack {
//					if isLoading {
//						Image(uiImage: Asset.Pokeball.pokeball.image)
//							.resizable()
//							.aspectRatio(contentMode: .fit)
//							.frame(height: 150)
//							.rotationEffect(Angle(degrees: animating ? 360 : 0.0))
//							.animation(repeatForeverAnimation, value: $isLoading)
//							.opacity(0.4)
//							.onAppear {
//								animating = true
//							}
//							.onDisappear {
//								animating = false
//							}
//					}
//				}
//			)
	}
}

struct RemoteImageView_Previews: PreviewProvider {
	@State static var url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/314.png"
	
    static var previews: some View {
		RemoteImageView(url: $url)
    }
}
