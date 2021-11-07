//
//  RemoteImageView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/3/21.
//

import SwiftUI
import PokeSwift

struct RemoteImageView<Content: View, Placeholder: View>: View {
	@State private var fetchedImage: UIImage?
	@State private var loading: Bool = false
	@State var url: String
	
	let image: (Image) -> Content
	let placeHolder: () -> Placeholder
	
	init(url: String,
		 @ViewBuilder image: @escaping (Image) -> Content,
		 @ViewBuilder placeholder: @escaping () -> Placeholder) {
		self.url = url
		self.image = image
		self.placeHolder = placeholder
	}
	
    var body: some View {
		VStack {
			if loading {
				placeHolder()
			} else if let fetchedImage = fetchedImage {
				image(Image(uiImage: fetchedImage))
			}
		}
		.animation(.linear(duration: 0.25),
				   value: fetchedImage)
		.task {
			await loadImage(from: url)
		}
    }
	
	@MainActor
	func loadImage(from url: String) async {
		guard !loading,
			  let URL = URL(string: url) else {
			return
		}
		
		if let cachedImage = imageCache[url] {
			self.fetchedImage = cachedImage
			return
		}
		
		loading = true
		defer { loading = false }
		
		do {
			let configuration = URLSessionConfiguration.default
			configuration.urlCache = .shared
			configuration.requestCachePolicy = .returnCacheDataElseLoad
			let urlSession = URLSession(configuration: configuration)
			
			let (data, response) = try await urlSession.data(from: URL)
			
			if let uiImage = UIImage(data: data) {
				self.fetchedImage = uiImage
				imageCache[url] = uiImage
			} else if let httpResponse = response as? HTTPURLResponse {
				print("Failed to get remote image. Status code: \(httpResponse.statusCode)")
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}

//struct RemoteImageView_Previews: PreviewProvider {
//	@State static var url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/314.png"
//
//    static var previews: some View {
//		RemoteImageView(url: $url)
//    }
//}
