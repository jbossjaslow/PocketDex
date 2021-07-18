//
//  SpriteGallery.swift
//  SpriteGallery
//
//  Created by Josh Jaslow on 7/18/21.
//

import SwiftUI
import PokeSwift

struct SpriteGallery: View {
	@EnvironmentObject var viewModel: PokemonViewModel
	
	private func getScale(proxy: GeometryProxy) -> CGFloat {
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
	
	var body: some View {
		ScrollView(.horizontal) {
			ScrollViewReader { scrollProxy in
				HStack(spacing: 0) {
					ForEach(viewModel.pokemonSprites, id: \.url) { (spriteName,
																	spriteURL) in
						GeometryReader { geometryProxy in
							let scale = getScale(proxy: geometryProxy)
							
							VStack(spacing: 0) {
								AsyncImage(url: URL(string: spriteURL)) { image in
									image
										.resizable()
										.scaledToFit()
										.frame(width: 200)
										.clipped()
										.shadow(radius: 4)
										.scaleEffect(scale)
										.animation(.easeOut(duration: 0.1),
												   value: scale)
										.id(spriteURL)
									//									.background(Color.blue)
								} placeholder: {
									Image(uiImage: Asset.Pokeball.pokeball.image)
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 50, height: 50)
								}
								
								Text(spriteName)
									.padding(.top, -10)
									.padding(.bottom)
							}
							.onTapGesture {
								withAnimation(.easeOut(duration: 0.1)) {
									scrollProxy.scrollTo(spriteURL,
														 anchor: .center)
								}
							}
						}
//						.background(.red)
						.frame(width: 200)
					}
				}
			}
		}
		.frame(height: 200)
	}
}

struct SpriteGallery_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "3")
		
		SpriteGallery()
			.environmentObject(viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
		//			.environmentObject(PokemonViewModel(url: Pokemon.url + "10186"))
	}
}
