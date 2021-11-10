//
//  PokemonTypesStack.swift
//  PokemonTypesStack
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI
import PokeSwift

struct PokemonTypesStack: View {
	@EnvironmentObject var viewModel: PokemonViewModel
	
    var body: some View {
		HStack(spacing: 5) {
			ForEach(viewModel.typeMaps, id: \.name) { typeMap in
				NavigationLink(destination: TypeDetail().environmentObject(TypeViewModel(typeMap: typeMap))) {
					Image(uiImage: typeMap.iconRectangular)
						.resizable()
						.scaledToFit()
						.border(Color.white, width: 2)
				}
			}
		}
		.frame(height: 50)
    }
}

struct PokemonTypesStack_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel1Type = PokemonViewModel(speciesURL: Pokemon.url + "6")
		
		PokemonTypesStack()
			.environmentObject(viewModel1Type)
			.task {
				await viewModel1Type.fetchPokemon()
			}
			.previewLayout(.sizeThatFits)
    }
}
