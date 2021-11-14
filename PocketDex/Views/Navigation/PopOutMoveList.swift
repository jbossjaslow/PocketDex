//
//  PopOutMoveList.swift
//  PopOutMoveList
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

struct PopOutMoveList: View {
	@ObservedObject var viewModel: PopOutMoveListViewModel
	
	init(title: String,
		 resources: Binding<[PokemonMoveData]>) {
		self.viewModel = PopOutMoveListViewModel(title: title,
												 resources: resources)
	}
	
	var body: some View {
		Text(viewModel.title)
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
			ForEach(viewModel.orderedFilteredResources) { resource in
				let viewModel = MoveViewModel(moveName: resource.moveName)
				
				VStack {
					Text(resource.moveName.capitalizingFirstLetter())
						.bold()
					
					Text(resource.learnMethod.rawValue)
					
					Text("Level learned at: \(resource.levelLearned)")
				}
				.navigableTo(MoveDetail(viewModel: viewModel))
			}
		}
		.navigationTitle(viewModel.title)
		.searchable(text: $viewModel.searchText)
		.disableAutocorrection(true)
		.onAppear {
			viewModel.runOnAppear()
		}
		.toolbar {
			HStack {
				Menu {
					Picker("", selection: $viewModel.ordering) {
						ForEach(MoveOrdering.allCases, id: \.self) { ordering in
							Text(ordering.rawValue)
								.tag(ordering.rawValue)
						}
					}
				} label: {
					Image(systemName: "arrow.up.and.down")
						.foregroundColor(.blue)
						.padding(.trailing, 10)
				}
				
				Menu {
					Picker("", selection: $viewModel.selectedVersion) {
						ForEach(viewModel.genSet.sortedSet, id: \.self) { gen in
							Text(gen.rawValue)
								.tag(gen.rawValue)
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
