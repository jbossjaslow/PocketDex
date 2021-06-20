//
//  DamageRelations.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/15/21.
//

import SwiftUI
import PokeSwift

struct DamageRelations: View {
	@EnvironmentObject var viewModel: TypeViewModel
	
	var body: some View {
		HStack {
			VStack {
				Text("Offensive")
					.font(.title)
				
				TypeRelationView(typeRelationship: .doubleDamageTo)
				
				Spacer()
				
				TypeRelationView(typeRelationship: .halfDamageTo)
				
				Spacer()
				
				TypeRelationView(typeRelationship: .noDamageTo)
			}
			
			Spacer()
			
			VStack {
				Text("Defensive")
					.font(.title)
				
				TypeRelationView(typeRelationship: .halfDamageFrom)
				
				Spacer()
				
				TypeRelationView(typeRelationship: .doubleDamageFrom)
				
				Spacer()
				
				TypeRelationView(typeRelationship: .noDamageFrom)
			}
		}
		.padding(.horizontal, 5)
	}
}

struct DamageRelations_Previews: PreviewProvider {
	static var normalType = TypeMap(color: Asset.PokemonType.Color.normal.color,
									iconCircular: Asset.PokemonType.Icons.normalCircular.image,
									iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
									name: "normal")
	
	static var previews: some View {
		DamageRelations()
			.environmentObject(TypeViewModel(typeMap: normalType))
	}
}
