//
//  PokemonWithThisType.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/16/21.
//

import SwiftUI

struct PokemonWithThisType: View {
	@EnvironmentObject var viewModel: TypeViewModel
	
    var body: some View {
		if let pokemonWithThisType = viewModel.pokemonType?.pokemon {
			Text("Pokemon with this type: \(pokemonWithThisType.count)")
			ScrollView(.vertical, showsIndicators: true) {
				VStack {
					ForEach(pokemonWithThisType, id: \.pokemon?.name) { pokemon in
						Text(pokemon.pokemon?.name.capitalizingFirstLetter() ?? "Pokemon name")
						//on tap view, go to detail view
					}
				}
			}
			.border(Color.white)
			.frame(height: 200)
		} else {
			Text("Error Loading pokemon with this type")
		}
    }
}

struct PokemonWithThisType_Previews: PreviewProvider {
	static var normalType = TypeMap(color: Asset.PokemonType.Color.normal.color,
									iconCircular: Asset.PokemonType.Icons.normalCircular.image,
									iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
									name: "normal")
	
    static var previews: some View {
        PokemonWithThisType()
			.environmentObject(TypeViewModel(typeMap: normalType))
    }
}
