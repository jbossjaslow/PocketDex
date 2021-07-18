//
//  PopOutList.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/27/21.
//

import SwiftUI
import PokeSwift

struct PopOutList<T: Requestable>: View {
	@State var title: String
	@Binding var resources: [NamedAPIResource<T>]
	
	@State private var searchText: String = ""
	private var filteredResources: [NamedAPIResource<T>] {
		if !searchText.isEmpty {
			return resources.filter { $0.name.contains(searchText.lowercased()) }
		} else {
			return resources
		}
	}
	
    var body: some View {
		NavigationLink(destination: listView) {
//			HStack {
//				Spacer()
				Text(title)
//				.frame(maxWidth: .infinity)
//					.foregroundColor(.white)
//					.bold()
//					.padding()
//				Spacer()
//			}
//			.border(Color.white, width: 2)
		}
		.buttonStyle(.bordered)
		.controlSize(.large)
		.tint(.black)
		.onTapGesture {
			print("Tapped")
		}
    }
	
	var listView: some View {
		List {
			ForEach(filteredResources, id: \.name) { resource in
				switch T.self {
					case is Move.Type:
						NavigationLink(destination: MoveDetail(viewModel: MoveViewModel(moveName: resource.name))) {
							Text(resource.name)
						}
					case is Pokemon.Type:
						NavigationLink(destination: PokemonDetail(viewModel: PokemonViewModel(url: resource.url))) {
							Text(resource.name)
						}
					default:
						Text("Error - no known destination view")
				}
			}
		}
		.navigationTitle(title)
		.searchable(text: $searchText)
	}
}

struct PopOutList_Previews: PreviewProvider {
	@State static var viewModel = TypeViewModel(typeName: "normal")
	
    static var previews: some View {
		NavigationView {
			PopOutList<Pokemon>(title: "Pokemon with this Type",
								resources: $viewModel.pokemonWithThisType)
				.task {
					await viewModel.fetchTypes()
				}
				.padding()
			.background(Color.green)
		}
    }
}
