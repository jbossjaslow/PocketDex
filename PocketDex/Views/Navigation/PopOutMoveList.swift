//
//  PopOutMoveList.swift
//  PopOutMoveList
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

struct PopOutMoveList: View {
	@State var title: String
	@State var selectedGen: String
	@Binding var resources: [String: [PokemonMoveData]]
	
	@State private var searchText: String = ""
	private var filteredResources: [PokemonMoveData] {
		if !searchText.isEmpty {
			return resources[selectedGen]?.filter { $0.moveName.contains(searchText.lowercased()) } ?? []
		} else {
			return resources[selectedGen] ?? []
		}
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
			selectedGen = resources.keys.sorted().first ?? "none"
		}
		.toolbar {
			Menu {
				Picker("", selection: $selectedGen) {
					ForEach(resources.keys.sorted(), id: \.self) { gen in
						Text(gen).tag(gen)
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
