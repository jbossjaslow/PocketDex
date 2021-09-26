//
//  PokemonImageView.swift
//  PokemonImageView
//
//  Created by Josh Jaslow on 9/5/21.
//

import SwiftUI
import PokeSwift

struct PokemonImageView: View {
	
	var proxy: GeometryProxy?
	var sprite: String
	var name: String
	var textEmphasized: Bool = false
	
	init(proxy: GeometryProxy? = nil,
		 imageScale: CGFloat = 1,
		 sprite: String,
		 name: String,
		 textEmphasized: Bool = false) {
		self.proxy = proxy
		self.sprite = sprite
		self.name = name
		self.textEmphasized = textEmphasized
	}
	
    var body: some View {
		VStack {
			AsyncImage(url: URL(string: sprite)) { image in
				let scale = getScale(proxy: proxy)
				
				image
					.resizable()
					.scaledToFit()
					.frame(width: 200)
					.clipped()
					.shadow(radius: 4)
					.scaleEffect(scale)
					.animation(.easeOut(duration: 0.1),
							   value: scale)
					.id(sprite)
			} placeholder: {
				PlaceholderImageView()
			}
			
			Text(name)
				.foregroundColor(.black)
				.if(textEmphasized) {
					$0.bold().underline()
				}
				.padding(.top, -10)
				.padding(.bottom)
		}
	}
	
	private func getScale(proxy: GeometryProxy?) -> CGFloat {
		guard let proxy = proxy else {
			return 1
		}

		var scale: CGFloat = 1

		// point of interest, used for measuring where we are
		let poi = proxy.frame(in: .global).midX

		// current distance between point of interest and center point of scale
		let diff = abs(poi - proxy.size.width)

		// Width of area around scale in which scale should occur
		let animationAreaWidth: CGFloat = 100

		// Rate of change of scale inside animation area width
		// Higher value means smaller change
		let scaleSlope: CGFloat = 300

		// width around point in which scale animation will occur
		if diff < animationAreaWidth {
			scale = 1 + (animationAreaWidth - diff) / scaleSlope
		}

//		let x = proxy.frame(in: .global).minX
//		let diff = abs(x-paddingAmt)
//
//		if diff < 100 {
//			scale = 1 + (100 - diff) / 300
//		}

		return scale
	}
}

struct PokemonImageView_Previews: PreviewProvider {
    static var previews: some View {
		PokemonImageView(imageScale: 1,
						 sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
						 name: "Bulbasaur")
    }
}
