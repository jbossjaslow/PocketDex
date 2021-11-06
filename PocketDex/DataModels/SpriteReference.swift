//
//  SpriteReference.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/9/21.
//

import Foundation

struct SpriteReference {
	var name: String
	let spriteUrl: String
	var pokemonUrl: String?
	let id: UUID
	
	init(name: String,
		 spriteUrl: String,
		 pokemonUrl: String? = nil) {
		self.name = name
		self.spriteUrl = spriteUrl
		self.pokemonUrl = pokemonUrl
		self.id = UUID()
	}
}

extension SpriteReference: Equatable, Identifiable {}
