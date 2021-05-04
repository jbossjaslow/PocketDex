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
	
    var body: some View {
		VStack {
			if let fetchedImage = image {
				Image(uiImage: fetchedImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.overlay(
						HStack {
							if loading {
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle())
							}
						}
					)
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
		loading = true
		SessionManager.requestImage(url: url) { result in
			if case .success(let image) = result {
				self.image = image
			}
			loading = false
		}
	}
}

struct RemoteImageView_Previews: PreviewProvider {
	@State static var url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/314.png"
	
    static var previews: some View {
		RemoteImageView(url: $url)
    }
}
