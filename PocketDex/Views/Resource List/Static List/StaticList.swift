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
					Text(resource.name.capitalizingFirstLetter())
				}
			}
			.loadingResource(isLoading: $viewModel.isLoading)
			.addSearchBar(searchText: $viewModel.searchText)
			.navigationTitle(String(describing: T.self))
			.listStyle(PlainListStyle())
		}
    }
}

struct StaticList_Previews: PreviewProvider {
    static var previews: some View {
        StaticList<Pokemon>()
    }
}
