//
//  StaticList.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift

struct StaticList<T: Requestable & ResourceLimit>: View {
	@ObservedObject private var viewModel: StaticListViewModel<T>
	
	init() {
		self.viewModel = StaticListViewModel<T>()
	}
	
    var body: some View {
		NavigationView {
			List {
				ForEach(viewModel.arrangedResources, id: \.name) { resource in
					let name = resource.name
					switch T.self {
						case is Pokemon.Type:
							let viewModel = PokemonViewModel(url: resource.url,
															 name: name)
							Text(name)
								.navigationTitle("Pokemon")
								.navigableTo(PokemonDetail(viewModel: viewModel))
							
						case is Move.Type:
							let viewModel = MoveViewModel(moveName: name)
							
							Text(name)
								.navigationTitle("Moves")
								.navigableTo(MoveDetail(viewModel: viewModel))
						case is Ability.Type:
							let viewModel = AbilityViewModel(name: name)
							
							Text(name)
								.navigationTitle("Abilities")
								.navigableTo(AbilityDetail(viewModel: viewModel))
						default:
							Text(name)
					}
				}
			}
//			.loadingResource(isLoading: $viewModel.isLoading)
			.searchable(text: $viewModel.searchText)
//			.navigationTitle(String(describing: T.self)) // Causes UIViewAlertForUnsatisfiableConstraints warning
			.listStyle(PlainListStyle())
			.toolbar {
				Menu {
					Picker("", selection: $viewModel.ordering) {
						Text(Ordering.default.rawValue).tag(Ordering.default)
						Text(Ordering.alphabetical.rawValue).tag(Ordering.alphabetical)
					}
				} label: {
					Image(systemName: "arrow.up.and.down")
						.padding(.trailing, 10)
				}
			}
		}
		.accentColor(.black)
		.task {
			await viewModel.populateResourceList()
		}
    }
}

struct StaticList_Previews: PreviewProvider {
    static var previews: some View {
        StaticList<Pokemon>()
    }
}
