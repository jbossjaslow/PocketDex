//
//  TypeDetail.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/14/21.
//

import SwiftUI
import PokeSwift

struct TypeDetail: View {
	@EnvironmentObject var viewModel: TypeViewModel
	
    var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			VStack {
				if let map = viewModel.typeMap {
					Image(uiImage: map.iconCircular)
						.aspectRatio(contentMode: .fit)
//							.shadow(color: .white, radius: 20, x: 0, y: 0)
						.overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
				}
				
				//Name
				Text(viewModel.pokemonType?.name?.capitalizingFirstLetter() ?? "Pokemon Type")
				
				//Damage type dealt from gens 1-3
//					Button {
//						//go to detail view
//					} label: {
//						Text(viewModel.pokemonType?.moveDamageClass?.name.capitalizingFirstLetter() ?? "Move damage class")
//					}
				
				//Introduced in generation
				Button {
					//go to detail view
				} label: {
					Text(viewModel.pokemonType?.generation?.name.capitalizingFirstLetter() ?? "Generation introduced")
				}
				
				//Game indices
				if let gameIndices = viewModel.pokemonType?.gameIndices {
					Text("Game indices: \(gameIndices.count)")
					VStack {
						ForEach(gameIndices, id: \.generation?.name) { index in
							Text(index.generation?.name.capitalizingFirstLetter() ?? "Game index")
							//on tap view, go to detail view
						}
					}
					.border(Color.white)
				}
				
				//List of relationships to attack/defense effectiveness with other types
				DamageRelations()
					.padding(5)
				
				//List of pokemon with this type
				PokemonWithThisType()
				
				//List of moves with this type
				MovesWithThisType()
			}
			.padding(.bottom)
		}
		.background(Color(viewModel.typeMap!.color.cgColor).edgesIgnoringSafeArea(.all))
		.task {
			await viewModel.fetchTypes()
		}
    }
}

struct TypeTest_Previews: PreviewProvider {
	static var normalType = TypeMap(color: Asset.PokemonType.Color.normal.color,
									iconCircular: Asset.PokemonType.Icons.normalCircular.image,
									iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
									name: "normal")
	
    static var previews: some View {
        TypeDetail()
			.environmentObject(TypeViewModel(typeMap: normalType))
    }
}
