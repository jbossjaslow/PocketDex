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
		VStack {
			HStack {
				Text(viewModel.showingDamageRelations ? "Hide Damage Relations" : "Show Damage Relations")
					.font(.title)
					.padding(.trailing)
				
				Image(systemName: "chevron.forward")
					.rotationEffect(Angle(degrees: viewModel.showingDamageRelations ? 90 : 0))
					.font(.title)
				
				Spacer()
			}
			.onTapGesture {
				viewModel.showingDamageRelations.toggle()
			}
			
			if viewModel.showingDamageRelations {
				HStack {
					VStack(spacing: 10) {
						Text("Offensive")
							.font(.title)
						
						Divider()
						
						TypeRelationView(typeRelationship: .doubleDamageTo)
						
						TypeRelationView(typeRelationship: .halfDamageTo)
						
						TypeRelationView(typeRelationship: .noDamageTo)
					}
					.frame(minHeight: 50)
					
					Spacer()
					
					VStack(spacing: 10) {
						Text("Defensive")
							.font(.title)
						
						Divider()
						
						TypeRelationView(typeRelationship: .halfDamageFrom)
						
						TypeRelationView(typeRelationship: .doubleDamageFrom)
						
						TypeRelationView(typeRelationship: .noDamageFrom)
					}
					.frame(minHeight: 50)
				}
			}
		}
		.animation(.easeInOut,
				   value: viewModel.showingDamageRelations)
	}
}

struct DamageRelations_Previews: PreviewProvider {
	static var previews: some View {
		DamageRelations()
			.environmentObject(TypeViewModel(typeName: "normal"))
	}
}
