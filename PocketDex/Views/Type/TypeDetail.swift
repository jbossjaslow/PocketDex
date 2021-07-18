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
			ScrollViewReader { scrollProxy in
				VStack(spacing: 10) {
					if let map = viewModel.typeMap {
						Image(uiImage: map.iconCircular)
							.aspectRatio(contentMode: .fit)
						//							.shadow(color: .white, radius: 20, x: 0, y: 0)
							.overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
					}
					
					//Name
					Text(viewModel.pokemonType?.name?.capitalizingFirstLetter() ?? "Pokemon Type")
						.font(.largeTitle)
						.id("typeName")
						.onAppear {
							scrollProxy.scrollTo("typeName", anchor: .bottom)
						}
					
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
						.padding(.horizontal)
						.id("damageRelations")
						.onChange(of: viewModel.showingDamageRelations) { showingDamageRelations in
							withAnimation(.easeOut) {
								scrollProxy.scrollTo("damageRelations", anchor: .center)
							}
						}
					
					//List of pokemon with this type
					PopOutList<Pokemon>(title: "Pokemon with this type",
										resources: $viewModel.pokemonWithThisType)
						.padding(.horizontal)
						.animation(.easeInOut,
								   value: viewModel.showingDamageRelations)
					
					//List of moves with this type
					//				MovesWithThisType()
					PopOutList<Move>(title: "Moves with this type",
									 resources: $viewModel.movesWithThisType)
						.padding(.horizontal)
						.animation(.easeInOut,
								   value: viewModel.showingDamageRelations)
				}
				.padding(.bottom)
			}
		}
		.background(Color(viewModel.typeMap?.color ?? .white).edgesIgnoringSafeArea([.top, .leading, .trailing]))
		.task {
			await viewModel.fetchTypes()
		}
	}
}

struct TypeTest_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			TypeDetail()
				.environmentObject(TypeViewModel(typeName: "normal"))
		}
	}
}
