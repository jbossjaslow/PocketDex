//
//  AbilityDetail.swift
//  PocketDex
//
//  Created by Josh Jaslow on 7/17/21.
//

import SwiftUI
import PokeSwift

struct AbilityDetail: View {
	@ObservedObject var viewModel: AbilityViewModel
	
    var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			VStack(spacing: 10) {
				HStack {
					Spacer()
					
					Text(viewModel.abilityNameCapitalized)
						.font(.largeTitle)
					
					Spacer()
				}
				
				Text(viewModel.abilityEffectEnglish)
					.font(.title)
					.padding(.horizontal)
				
				PopOutList<Pokemon>(title: "Pokemon that can have this ability",
									resources: $viewModel.pokemonWithThisAbility)
					.padding(.horizontal)
			}
			.task {
				await viewModel.fetchAbility()
			}
		}
		.overlay(
			VStack {
				if viewModel.makingRequest {
					LoadingView()
				}
			}
		)
    }
}

struct AbilityDetail_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			AbilityDetail(viewModel: AbilityViewModel(name: "unaware"))
		}
    }
}
