//
//  PokemonAbilitiesStack.swift
//  PokemonAbilitiesStack
//
//  Created by Josh Jaslow on 7/25/21.
//

import SwiftUI
import PokeSwift

struct PokemonAbilitiesStack: View {
	@EnvironmentObject var viewModel: PokemonViewModel
	
    var body: some View {
		HStack(spacing: 5) {
			ForEach(viewModel.abilities, id: \.slot) { ability in
				NavigationLink(destination: AbilityDetail(viewModel: AbilityViewModel(name: ability.ability?.name ?? ""))) {
					HStack {
						Text(ability.ability?.name ?? "")
						
						if let isHidden = ability.isHidden,
						   isHidden == true {
							Image(systemName: "h.circle.fill")
								.scaleEffect(1.5)
						}
					}
				}
				.buttonStyle(.bordered)
				.tint(.white)
			}
		}
    }
}

struct PokemonAbilitiesStack_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "3")
		
        PokemonAbilitiesStack()
			.environmentObject(viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
    }
}
