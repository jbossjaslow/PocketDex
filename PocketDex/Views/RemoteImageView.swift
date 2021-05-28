//
//  RemoteImageView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/3/21.
//

import SwiftUI
import PokeSwift

var imageCache = ImageCache.getImageCache()

struct RemoteImageView: View {
	@State private var image: UIImage?
	@State private var loading: Bool = false
	@Binding var url: String
	
	init(url: Binding<String>) {
		self._url = url
	}
	
    var body: some View {
		VStack {
			Image(uiImage: image ?? Asset.Pokeball.pokeballSimple.image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.loadingImage(isLoading: $loading)
		}
		.onAppear {
			loadImage(from: url)
		}
		.onChange(of: url) { _ in
			loadImage(from: url)
		}
    }
	
	func loadImage(from url: String) {
		loading = true
		if !url.isEmpty,
		   let cachedImage = loadImageFromCache(url) {
			self.image = cachedImage
			loading = false
		} else {
			loadImageFromURL(url)
		}
	}
	
	func loadImageFromCache(_ url: String) -> UIImage? {
		print("Requesting image from cache")
		let image = imageCache.get(forKey: url)
		if image == nil {
			print("Image not found in cache")
		} else {
			print("Image found in cache")
		}
		return image
	}
	
	func loadImageFromURL(_ url: String) {
		if !url.isEmpty {
			print("Requesting image from URL")
		}
		
		SessionManager.requestImage(url: url) { result in
			if case .success(let image) = result {
				self.image = image
				print("Setting image in cache")
				imageCache.set(forKey: url,
							   image: image)
			}
			loading = false
		}
	}
}

class ImageCache {
	var cache = NSCache<NSString, UIImage>()
	
	func get(forKey: String) -> UIImage? {
		return cache.object(forKey: NSString(string: forKey))
	}
	
	func set(forKey: String, image: UIImage) {
		cache.setObject(image, forKey: NSString(string: forKey))
	}
}

extension ImageCache {
	private static var imageCache = ImageCache()
	static func getImageCache() -> ImageCache {
		return imageCache
	}
}

extension View {
	func loadingImage(isLoading: Binding<Bool>) -> some View {
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
			.overlay(
				HStack {
					if isLoading {
						Image(uiImage: Asset.Pokeball.pokeballSimple.image)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(height: 150)
							.rotationEffect(Angle(degrees: animating ? 360 : 0.0))
							.animation(repeatForeverAnimation)
							.onAppear {
								animating = true
							}
							.onDisappear {
								animating = false
							}
					}
				}
			)
	}
}

struct RemoteImageView_Previews: PreviewProvider {
	@State static var url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/314.png"
	
    static var previews: some View {
		RemoteImageView(url: $url)
    }
}
