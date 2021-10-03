//
//  PopOutMoveList.swift
//  PopOutMoveList
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

struct PopOutMoveList: View {
	@State var title: String
	@Binding var resources: [PokemonMoveData]
	
	@State private var searchText: String = ""
	private var filteredResources: [PokemonMoveData] {
		if !searchText.isEmpty {
			return resources.filter { $0.moveName.contains(searchText.lowercased()) }
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
			ForEach(filteredResources, id: \.moveName) { resource in
				let viewModel = MoveViewModel(moveName: resource.moveName)
				
				VStack {
					Text(resource.moveName.capitalizingFirstLetter())
						.bold()
					
					Text(resource.learnMethod.rawValue)
					
					Text("Level learned at: \(resource.minLevel)")
				}
				.navigableTo {
					MoveDetail(viewModel: viewModel)
				}
			}
		}
		.navigationTitle(title)
		.searchable(text: $searchText)
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
