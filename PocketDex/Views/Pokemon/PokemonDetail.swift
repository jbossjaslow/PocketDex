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
					Text(viewModel.speciesInfo.genus)
						.font(.largeTitle)
					
					// MARK: - Types
					PokemonTypesStack()
						.environmentObject(viewModel)
						.padding(.horizontal)
					
					// MARK: - Sprites and Evolutions
					VStack(spacing: 0) {
						SpriteGallery(viewModel: viewModel)
							.frame(height: 200)
						
						if viewModel.chainPokemonCollection.chainPokemon.count > 1 {
							PokemonEvolutionChainView(viewModel: viewModel)
								.frame(height: 200)
						}
						
						if viewModel.variantSprites.count > 1 {
							PokemonVariantsGallery(viewModel: viewModel)
								.frame(height: 200)
						}
					}
					.padding(.bottom, 20)
					
					// MARK: - Abilities
					PokemonAbilitiesStack()
						.environmentObject(viewModel)
						.padding(.horizontal)
					
					// MARK: - Stats
					StatsView(viewModel: viewModel)
						.padding()
						.id("stats")
						.onChange(of: viewModel.showingStats) { value in
//							withAnimation(.easeOut(duration: 0.25)) {
								proxy.scrollTo("stats",
											   anchor: .bottom)
//							}
						}
					
					// MARK: - Moves
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
				.overlay(
					Color("initialBackgroundColor")
						.edgesIgnoringSafeArea(.all)
						.opacity(viewModel.makingRequest ? 1 : 0)
						.animation(.linear(duration: 0.5),
								   value: viewModel.makingRequest)
				)
		)
//		.navigationBarHidden(true)
		.navigationTitle(viewModel.displayName.capitalizingFirstLetter() + " " +  viewModel.speciesInfo.id.description)
		.overlay(
			VStack {
				if viewModel.makingRequest {
					LoadingView()
				}
			}
		)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			PokemonDetail(viewModel: PokemonViewModel(speciesURL: Pokemon.url + "3"))
		}
	}
}
