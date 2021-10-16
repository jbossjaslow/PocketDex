//
//  PopOutMoveList.swift
//  PopOutMoveList
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

struct PopOutMoveList: View {
	@State var title: String
	@State var selectedGen: String = ""
	@Binding var resources: [PokemonMoveData]
	
	@State private var searchText: String = ""
	
	private var genSet: GenerationSet {
		GenerationSet(gens: self.resources.map { $0.generation })
	}
	private var filteredGenResources: [PokemonMoveData] {
		resources.filter { $0.generation == selectedGen }
	}
	private var filteredResources: [PokemonMoveData] {
		if !searchText.isEmpty {
			return filteredGenResources.filter { $0.moveName.contains(searchText.lowercased()) }
		} else {
			return filteredGenResources
		}
	}
	
	init(title: String,
		 resources: Binding<[PokemonMoveData]>) {
		self.title = title
		self._resources = resources
		self.selectedGen = genSet.sortedSet.first?.rawValue ?? "none"
	}
	
	var body: some View {
		Text(title)
			.navigableTo(listView)
		.buttonStyle(.bordered)
		.controlSize(.large)
		.tint(.black)
		.onTapGesture {
			print("Tapped")
		}
	}
	
	var listView: some View {
		List {
			ForEach(filteredResources, id: \.moveName) { resource in
				let viewModel = MoveViewModel(moveName: resource.moveName)
				
				VStack {
					Text(resource.moveName.capitalizingFirstLetter())
						.bold()
					
					Text(resource.learnMethod.rawValue)
					
					Text("Level learned at: \(resource.minLevel)")
				}
				.navigableTo(MoveDetail(viewModel: viewModel))
			}
		}
		.navigationTitle(title)
		.searchable(text: $searchText)
		.onAppear {
			selectedGen = genSet.sortedSet.first?.rawValue ?? "none"
		}
		.toolbar {
			Menu {
				Picker("", selection: $selectedGen) {
					ForEach(genSet.sortedSet, id: \.self) { gen in
						Text(gen.rawValue)
							.tag(gen.rawValue)
					}
				}
			} label: {
				Image(systemName: "arrow.up.and.down")
					.foregroundColor(.blue)
					.padding(.trailing, 10)
			}
		}
	}
}

//struct PopOutList_Previews: PreviewProvider {
//	@State static var viewModel = TypeViewModel(typeName: "normal")
//
//	static var previews: some View {
//		NavigationView {
//			PopOutMoveList(title: "Pokemon with this Type",
//						   resources: $viewModel.pokemonWithThisType)
//				.task {
//					await viewModel.fetchTypes()
//				}
//				.padding()
//			.background(Color.green)
//		}
//	}
//}
