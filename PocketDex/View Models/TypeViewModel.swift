//
//  TypeViewModel.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/16/21.
//

import SwiftUI
import PokeSwift

class TypeViewModel: ObservableObject {
	@Published var typeMap: TypeMap? = TypeMap(color: Asset.PokemonType.Color.normal.color,
									  iconCircular: Asset.PokemonType.Icons.normalCircular.image,
									  iconRectangular: Asset.PokemonType.Icons.normalRectangular.image,
									  name: "normal")
	@Published var pokemonType: Type?
	@Published var showingDamageRelations: Bool = false
	
	@Published var makingRequest: Bool = false
	
	@Published var pokemonWithThisType: [NamedAPIResource<Pokemon>] = []
	@Published var movesWithThisType: [NamedAPIResource<Move>] = []
	
	private var typeName: String
	
	init(typeName: String) {
		self.typeName = typeName
	}
	
	init(type: Type) {
		pokemonType = type
		typeMap = type.mapAdditionalInfo()
		typeName = type.name ?? "NAME ERROR"
	}
	
	convenience init(typeMap: TypeMap) {
		self.init(typeName: typeMap.name)
	}
	
	func fetchTypes() async {
		await fetchTypes(from: typeName)
	}
	
	func fetchTypes(from name: String) async {
		do {
			let fetchedType = try await Type.request(using: .name(name))
			self.pokemonType = fetchedType
			self.typeMap = fetchedType.mapAdditionalInfo()
			self.pokemonWithThisType = fetchedType.pokemon?.compactMap { $0.pokemon } ?? []
			self.movesWithThisType = fetchedType.moves ?? []
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
	
	func typeRelations(relationship: TypeRelationship) -> [String] {
		switch relationship {
			case .doubleDamageTo:
				return pokemonType?.damageRelations?.doubleDamageTo?.compactMap { $0.name } ?? []
			case .halfDamageTo:
				return pokemonType?.damageRelations?.halfDamageTo?.compactMap { $0.name } ?? []
			case .noDamageTo:
				return pokemonType?.damageRelations?.noDamageTo?.compactMap { $0.name } ?? []
			case .doubleDamageFrom:
				return pokemonType?.damageRelations?.doubleDamageFrom?.compactMap { $0.name } ?? []
			case .halfDamageFrom:
				return pokemonType?.damageRelations?.halfDamageFrom?.compactMap { $0.name } ?? []
			case .noDamageFrom:
				return pokemonType?.damageRelations?.noDamageFrom?.compactMap { $0.name } ?? []
		}
	}
}

//	let types = ["normal",
//				 "fighting",
//				 "flying",
//				 "poison",
//				 "ground",
//				 "rock",
//				 "bug",
//				 "ghost",
//				 "steel",
//				 "fire",
//				 "water",
//				 "grass",
//				 "electric",
//				 "psychic",
//				 "ice",
//				 "dragon",
//				 "dark",
//				 "fairy"]
