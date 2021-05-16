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
//		VStack {
//			HStack {
//				Spacer()
//
//				Text("Offensive")
//					.font(.title)
//
//				Spacer()
//
//				Text("Defensive")
//					.font(.title)
//
//				Spacer()
//			}
//
//			HStack {
//				TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.doubleDamageTo?.map { $0.name } ?? [],
//								 typeRelationship: .doubleDamageTo)
//
//				Spacer()
//
//				TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.halfDamageFrom?.map { $0.name } ?? [],
//								 typeRelationship: .halfDamageFrom)
//			}
//
//			HStack {
//				TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.halfDamageTo?.map { $0.name } ?? [],
//								 typeRelationship: .halfDamageTo)
//
//				Spacer()
//
//				TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.doubleDamageFrom?.map { $0.name } ?? [],
//								 typeRelationship: .doubleDamageFrom)
//			}
//
//			HStack {
//				TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.noDamageTo?.map { $0.name } ?? [],
//								 typeRelationship: .noDamageTo)
//
//				Spacer()
//
//				TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.noDamageFrom?.map { $0.name } ?? [],
//								 typeRelationship: .noDamageFrom)
//			}
//		}
		
				HStack {
					VStack {
						Text("Offensive")
							.font(.title)
		
						TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.doubleDamageTo?.map { $0.name } ?? [],
										 typeRelationship: .doubleDamageTo)
		
						Spacer()
		
						TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.halfDamageTo?.map { $0.name } ?? [],
										 typeRelationship: .halfDamageTo)
		
						Spacer()
		
						TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.noDamageTo?.map { $0.name } ?? [],
										 typeRelationship: .noDamageTo)
					}
		
					Spacer()
		
					VStack {
						Text("Defensive")
							.font(.title)
		
						TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.halfDamageFrom?.map { $0.name } ?? [],
										 typeRelationship: .halfDamageFrom)
		
						Spacer()
		
						TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.doubleDamageFrom?.map { $0.name } ?? [],
										 typeRelationship: .doubleDamageFrom)
		
						Spacer()
		
						TypeRelationView(typeRelations: viewModel.pokemonType?.damageRelations?.noDamageFrom?.map { $0.name } ?? [],
										 typeRelationship: .noDamageFrom)
					}
				}
				.padding(.horizontal, 5)
		
		//		VStack {
		//			if let noDamageTo = viewModel.pokemonType?.damageRelations?.noDamageTo,
		//			   noDamageTo.count > 0 {
		//				TypeRelationView(typeRelations: noDamageTo.map { $0.name },
		//								 typeRelationship: .noDamageTo)
		//			}
		//
		//			if let halfDamageTo = viewModel.pokemonType?.damageRelations?.halfDamageTo,
		//			   halfDamageTo.count > 0 {
		//				TypeRelationView(typeRelations: halfDamageTo.map { $0.name },
		//								 typeRelationship: .halfDamageTo)
		//			}
		//
		//			if let doubleDamageTo = viewModel.pokemonType?.damageRelations?.doubleDamageTo,
		//			   doubleDamageTo.count > 0 {
		//				TypeRelationView(typeRelations: doubleDamageTo.map { $0.name },
		//								 typeRelationship: .doubleDamageTo)
		//			}
		//
		//			if let noDamageFrom = viewModel.pokemonType?.damageRelations?.noDamageFrom,
		//			   noDamageFrom.count > 0 {
		//				TypeRelationView(typeRelations: noDamageFrom.map { $0.name },
		//								 typeRelationship: .noDamageFrom)
		//			}
		//
		//			if let halfDamageFrom = viewModel.pokemonType?.damageRelations?.halfDamageFrom,
		//			   halfDamageFrom.count > 0 {
		//				TypeRelationView(typeRelations: halfDamageFrom.map { $0.name },
		//								 typeRelationship: .halfDamageFrom)
		//			}
		//
		//			if let doubleDamageFrom = viewModel.pokemonType?.damageRelations?.doubleDamageFrom,
		//			   doubleDamageFrom.count > 0 {
		//				TypeRelationView(typeRelations: doubleDamageFrom.map { $0.name },
		//								 typeRelationship: .doubleDamageFrom)
		//			}
		//		}
		//		.padding()
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
