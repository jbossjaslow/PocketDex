//
//  MovesWithThisType.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/16/21.
//

import SwiftUI

struct MovesWithThisType: View {
	@EnvironmentObject var viewModel: TypeViewModel
	
    var body: some View {
		if let movesWithThisType = viewModel.pokemonType?.moves {
			Text("Moves with this type: \(movesWithThisType.count)")
			ScrollView(.vertical, showsIndicators: true) {
				VStack {
					ForEach(movesWithThisType, id: \.name) { move in
						Text(move.name.capitalizingFirstLetter())
						//on tap view, go to detail view
					}
				}
			}
			.border(Color.white)
			.frame(height: 200)
		} else {
			Text("Error Loading moves with this type")
		}
    }
}

struct MovesWithThisType_Previews: PreviewProvider {
	static var normalType = TypeMap(color: Asset.PokemonType.Color.normal.color,
									iconCircular: Asset.PokemonType.Icons.normalCircular.image,
									iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
									name: "normal")
	
    static var previews: some View {
        MovesWithThisType()
			.environmentObject(TypeViewModel(typeMap: normalType))
    }
}
