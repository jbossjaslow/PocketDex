//
//  PokemonDetail.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/2/21.
//

import SwiftUI
import PokeSwift

struct PokemonDetail: View {
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel: PokemonViewModel
	
	var body: some View {
		ScrollView {
			ScrollViewReader { proxy in
				LazyVStack {
					Text(viewModel.pokemonGenus)
						.font(.largeTitle)
					
					//Types
					PokemonTypesStack()
						.environmentObject(viewModel)
						.padding(.horizontal)
					
					//Sprites and Evolutions
					SpriteGallery()
						.frame(height: 200)
						.environmentObject(viewModel)
					
					PokemonEvolutionChainView()
						.environmentObject(viewModel)
						.frame(height: 200)
						.padding(.bottom)
					
					//Abilities
					PokemonAbilitiesStack()
						.environmentObject(viewModel)
						.padding(.horizontal)
					
					// Stats
					StatsView()
						.padding()
						.environmentObject(viewModel)
						.id("stats")
						.onChange(of: viewModel.showingStats) { value in
//							withAnimation(.easeOut(duration: 0.25)) {
								proxy.scrollTo("stats",
											   anchor: .bottom)
//							}
						}
					
					// Moves
					PopOutMoveList(title: "Moves Learned",
								   resources: $viewModel.movesLearned)
						.padding(.horizontal)
					
					Spacer()
						.frame(height: 200)
				}
			}
		}
		.task {
			await viewModel.fetchPokemon()
		}
		.background(
			LinearGradient(gradient: Gradient(colors: viewModel.backgroundGradient),
						   startPoint: .top,
						   endPoint: .bottom)
				.edgesIgnoringSafeArea([.top, .leading, .trailing])
		)
//		.navigationBarHidden(true)
		.navigationTitle(viewModel.pokemonName.capitalizingFirstLetter() + " " +  viewModel.pokemonID)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			PokemonDetail(viewModel: PokemonViewModel(url: Pokemon.url + "3"))
		}
	}
}
