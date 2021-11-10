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
			// placeholder vstack to allow for menu to appear while using if statement
			ZStack {
				ScrollViewReader { proxy in
					List {
						if viewModel.ordering == .alphabetical {
							ForEach(viewModel.alphabeticalResources.keys,
									id: \.self) { section in
								Section {
									InnerList(viewModel.alphabeticalResources[section] ?? [])
								} header: {
									Text(section.description)
								}
								.id(section)
							}
						} else {
							InnerList(viewModel.arrangedResources)
						}
					}
					.searchable(text: $viewModel.searchText)
					.disableAutocorrection(true)
		//			.navigationTitle(String(describing: T.self)) // Causes UIViewAlertForUnsatisfiableConstraints warning
					.listStyle(PlainListStyle())
					.sectionIndices(from: viewModel.alphabeticalResources.keys.elements,
									hidden: viewModel.ordering != .alphabetical,
									proxy: proxy)
				}
				
				if viewModel.isLoading {
					LoadingView(fillEntireBackground: true)
				}
			}
			.toolbar {
				HStack {
					Menu {
						Picker("", selection: $viewModel.ordering) {
							Text(PokemonOrdering.default.rawValue).tag(PokemonOrdering.default)
							Text(PokemonOrdering.alphabetical.rawValue).tag(PokemonOrdering.alphabetical)
						}
					} label: {
						Image(systemName: "arrow.up.and.down")
							.foregroundColor(.blue)
							.padding(.trailing, 10)
					}
					
					Menu {
						Picker("", selection: $viewModel.selectedGen) {
							Text("National Dex")
								.tag("national")
							
							ForEach(1...8, id: \.self) { genNum in
								Text("Generation \(genNum)")
									.tag(genNum.description)
							}
						}
					} label: {
						Text("Gen")
							.foregroundColor(.blue)
							.padding(.trailing, 10)
					}
				}
			}
		}
//		.accentColor(.black)
		.task {
			await viewModel.populateResourceList()
		}
    }
	
	private struct InnerList: View {
		let resources: [GenerationalResource<T>]
		
		init(_ resources: [GenerationalResource<T>]) {
			self.resources = resources
		}
		
		var body: some View {
			ForEach(resources, id: \.resource.name) { genResource in
				let name = genResource.resource.name
				switch T.self {
					case is PokemonSpecies.Type:
						let url = genResource.resource.url
						let viewModel = PokemonViewModel(speciesURL: url,
														 name: name)
						
						Text(url.speciesIdPadded + " | " + name)
							.font(.system(size: 16,
										  design: .monospaced))
							.navigationTitle("Pokemon")
							.navigableTo(PokemonDetail(viewModel: viewModel))
						
					case is Move.Type:
						let viewModel = MoveViewModel(moveName: name)
						
						Text(name)
							.font(.system(size: 16,
										  design: .monospaced))
							.navigationTitle("Moves")
							.navigableTo(MoveDetail(viewModel: viewModel))
					case is Ability.Type:
						let viewModel = AbilityViewModel(name: name)
						
						Text(name)
							.font(.system(size: 16,
										  design: .monospaced))
							.navigationTitle("Abilities")
							.navigableTo(AbilityDetail(viewModel: viewModel))
					default:
						Text(name)
				}
			}
		}
	}
}

struct StaticList_Previews: PreviewProvider {
    static var previews: some View {
        StaticList<Pokemon>()
    }
}
