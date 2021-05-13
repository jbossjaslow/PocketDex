//
//  TypeView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/8/21.
//

import SwiftUI
import PokeSwift

struct TypeView: View {
	var type: Type
	
    var body: some View {
		Button {
			
		} label: {
			HStack {
				Text(type.name ?? "Error getting type")
					.foregroundColor(.white)
			}
			.padding(10)
			.background(Color.blue)
			.cornerRadius(10)
		}
    }
}

struct TypeView_Previews: PreviewProvider {
	static func normalType() -> Type? {
		var type: Type? = nil
		
		Type.request(using: .string("normal")) { (_ result: Type?) in
			if let normalType = result {
				type = normalType
			}
		}
		
		return type
	}
	
    static var previews: some View {
		VStack {
			if let normalType = normalType() {
				TypeView(type: normalType)
			} else {
				Text("Error getting test type")
			}
		}
    }
}
