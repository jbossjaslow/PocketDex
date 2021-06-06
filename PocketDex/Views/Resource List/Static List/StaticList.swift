//
//  StaticList.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift

struct StaticList<T: Requestable & ResourceLimit>: View {
	@ObservedObject var viewModel = StaticListViewModel<T>()
	
    var body: some View {
		NavigationView {
			List {
				ForEach(viewModel.filteredResources, id: \.name) { resource in
					if T.self == Pokemon.self {
						// This preloads all of the calls, making it take super long to start the app
//						NavigationLink(destination: PokemonView(requestURL: resource.url)) {
//							Text(resource.name.capitalizingFirstLetter())
//						}
						
						// This lazy loads the destinations
						NavigationLink(destination: LazyNavigationView(PokemonView(requestURL: resource.url))) {
							Text(resource.name.capitalizingFirstLetter())
						}
					} else {
						Text(resource.name.capitalizingFirstLetter())
					}
				}
			}
			.loadingResource(isLoading: $viewModel.isLoading)
			.addSearchBar(searchText: $viewModel.searchText)
			.navigationTitle(String(describing: T.self))
			.listStyle(PlainListStyle())
			.onAppear {
				print("Showing \(String(describing: T.self))")
			}
//			.gesture(DragGesture()
//						 .onChanged({ _ in
//							 UIApplication.shared.dismissKeyboard()
//						 })
		}
    }
}

struct StaticList_Previews: PreviewProvider {
    static var previews: some View {
        StaticList<Pokemon>()
    }
}
