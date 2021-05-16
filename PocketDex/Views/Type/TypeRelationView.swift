//
//  TypeRelationshipView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/15/21.
//

import SwiftUI
import PokeSwift

enum TypeRelationship: String {
//	case noDamageTo = "No damage to:"
//	case halfDamageTo = "Half damage to:"
//	case doubleDamageTo = "Double damage to:"
//	case noDamageFrom = "No damage from:"
//	case halfDamageFrom = "Half damage from:"
//	case doubleDamageFrom = "Double damage from:"
	
	case noDamageTo = "0x-to"
	case halfDamageTo = "½x-to"
	case doubleDamageTo = "2x-to"
	case noDamageFrom = "0x-from"
	case halfDamageFrom = "½x-from"
	case doubleDamageFrom = "2x-from"
}

struct TypeRelationView: View {
//	var typeRelations: [NamedAPIResource<Type>]
	@State var typeRelations: [String]
	
	let typeRelationship: TypeRelationship
	var typeRelationshipText: String {
		let arr = typeRelationship.rawValue.components(separatedBy: "-")
		return arr[0]
	}
	
	var backgroundColor: Color {
		switch typeRelationship {
			case .doubleDamageTo,
				 .doubleDamageFrom:
				return Color.green
			case .halfDamageTo,
				 .halfDamageFrom:
				return Color.red
			case .noDamageTo,
				 .noDamageFrom:
				return Color.black
		}
	}
	
	var foregroundColor: Color {
		switch typeRelationship {
			case .noDamageTo,
				 .noDamageFrom:
				return Color.white
			default:
				return Color.black
		}
	}
	
	var body: some View {
		HStack(spacing: 5) {
			VStack {
				Spacer()
				Text(typeRelationshipText)
					.font(.title)
					.foregroundColor(foregroundColor)
					.frame(width: 50)
				Spacer()
			}
			.background(backgroundColor)
			
			ScrollView(.horizontal, showsIndicators: false) {
				if typeRelations.count > 0 {
					HStack(spacing: 5) {
						ForEach(typeRelations, id: \.self) { typeName in
							NavigationLink(destination: TypeTest().environmentObject(TypeViewModel(typeName: typeName))) {
								Image(uiImage: Type.mapAdditionalInfo(typeName)!.iconCircular)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: 75)
									.overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
							}
						}
					}
				} else {
					Text("None")
						.frame(width: 75, height: 75)
				}
			}
		}
	}
}

struct TypeRelationView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			VStack {
				TypeRelationView(typeRelations: ["rock",
												 "steel"],
								 typeRelationship: .halfDamageTo)
				
				TypeRelationView(typeRelations: ["electric",
												 "grass",
												 "dragon"],
								 typeRelationship: .doubleDamageTo)
				
				TypeRelationView(typeRelations: [],
								 typeRelationship: .noDamageFrom)
	//				.scaleEffect(0.75)
			}
			.navigationBarHidden(true)
			.background(Color.black)
		}
	}
}
