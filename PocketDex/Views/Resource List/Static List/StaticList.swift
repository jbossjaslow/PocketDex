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
					switch T.self {
						case is Pokemon.Type:
							// This preloads all of the calls, making it take super long to start the app
							NavigationLink(destination: PokemonDetail(viewModel: PokemonViewModel(url: resource.url))) {
								Text(resource.name.capitalizingFirstLetter())
							}
							
							// This lazy loads the destinations
	//						NavigationLink(destination: LazyNavigationView(PokemonDetail(requestURL: resource.url))) {
	//							Text(resource.name.capitalizingFirstLetter())
	//						}
						case is Move.Type:
							NavigationLink(destination: MoveDetail(viewModel: MoveViewModel(moveName: resource.name))) {
								Text(resource.name)
							}
						case is Ability.Type:
							NavigationLink(destination: AbilityDetail(viewModel: AbilityViewModel(name: resource.name))) {
								Text(resource.name)
							}
						default:
							Text(resource.name.capitalizingFirstLetter())
					}
				}
			}
//			.loadingResource(isLoading: $viewModel.isLoading)
			.searchable(text: $viewModel.searchText)
			.navigationTitle(String(describing: T.self)) // Causes UIViewAlertForUnsatisfiableConstraints warning
			.listStyle(PlainListStyle())
			.task {
				await viewModel.populateResourceList()
			}
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
//			.gesture(DragGesture()
//						 .onChanged({ _ in
//							 UIApplication.shared.dismissKeyboard()
//						 })
		}
		.accentColor(.black)
    }
}

struct StaticList_Previews: PreviewProvider {
    static var previews: some View {
        StaticList<Pokemon>()
    }
}
