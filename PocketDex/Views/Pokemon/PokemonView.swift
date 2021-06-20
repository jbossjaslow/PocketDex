//
//  ContentView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/2/21.
//

import SwiftUI
import PokeSwift

struct PokemonView: View {
	@ObservedObject var viewModel: PokemonViewModel
	
    var body: some View {
		VStack {
			Spacer()
			
			//Name & Genus
			HStack {
				Text(viewModel.pokemonName.capitalizingFirstLetter())
					.font(.largeTitle)
				
				Text("|")
					.font(.largeTitle)
				
				Text(viewModel.pokemonGenus)
					.font(.largeTitle)
			}
			.padding()
			
			//Types
			HStack(spacing: 5) {
				ForEach(viewModel.typeMaps, id: \.name) { typeMap in
					NavigationLink(destination: TypeDetail().environmentObject(TypeViewModel(typeMap: typeMap))) {
						Image(uiImage: typeMap.iconRectangular)
							.border(Color.white, width: 2)
					}
				}
			}
			
			//Sprite
			AsyncImage(url: URL(string: viewModel.pokemonFrontSprite)) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
			} placeholder: {
				Image(uiImage: Asset.Pokeball.pokeball.image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 50, height: 50)
			}
			
			Spacer()
		}
		.task {
			await viewModel.fetchPokemon()
		}
		.background(
			LinearGradient(gradient: Gradient(colors: viewModel.backgroundGradient),
						   startPoint: .top,
						   endPoint: .bottom)
		)
		.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			PokemonView(viewModel: PokemonViewModel(url: Pokemon.url + "1"))
		}
    }
}
