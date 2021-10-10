//
//  SpriteReference.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/9/21.
//

import Foundation

struct SpriteReference {
	let name: String
	let url: String
	let id: UUID
	
	init(name: String,
		 url: String) {
		self.name = name
		self.url = url
		self.id = UUID()
	}
}

extension SpriteReference: Equatable, Identifiable {}
