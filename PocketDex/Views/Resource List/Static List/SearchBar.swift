//
//  SearchBar.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI

extension View {
	func addSearchBar(searchText: Binding<String>) -> some View {
		self.modifier(SearchBarModifier(searchText: searchText))
	}
}

struct SearchBarModifier: ViewModifier {
	@Binding var searchText: String
	
	func body(content: Content) -> some View {
		VStack(spacing: 0) {
			SearchBar(searchText: $searchText)
			
			content
		}
	}
}

fileprivate struct SearchBar: View {
	@Binding var searchText: String
	
	var body: some View {
		ZStack {
			Rectangle()
				.fill(Color(.lightGray).opacity(0.5))
			
			HStack {
				Image(systemName: "magnifyingglass")
				
				TextField("Search...", text: $searchText)
			}
			.foregroundColor(.gray)
			.padding(.leading, 13)
		}
		.frame(height: 40)
		.cornerRadius(13)
		.padding()
	}
}

struct SearchBar_Previews: PreviewProvider {
	static var previews: some View {
		SearchBar(searchText: .constant("Bulbasaur"))
	}
}
