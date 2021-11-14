//
//  PopOutMoveList.swift
//  PopOutMoveList
//
//  Created by Josh Jaslow on 9/19/21.
//

import SwiftUI

enum MoveOrdering: String, CaseIterable {
	case alphabetical = "A to Z"
	case `default` = "Default"
	case level = "Level learned at"
	case type = "Learn method"
}

struct PopOutMoveList: View {
	@State var title: String
	@Binding var resources: [PokemonMoveData]
	@State private var searchText: String = ""
	
	@State var selectedVersion: VersionGroupName = .redBlue
	@State var ordering: MoveOrdering = .default
	
	private var genSet: GenerationSet {
//		GenerationSet(gens: self.resources.map { $0.generation })
		let allVersionsFromAllMoves = self.resources.map {
			$0.getAllVersions()
		}
		let reducedVersionArr = allVersionsFromAllMoves.reduce([], +)
		return GenerationSet(gens: reducedVersionArr)
	}
	private var filteredResourcesForVersion: [PokemonMoveData] {
//		resources.filter { $0.generation == selectedGen }
		resources.filter {
			$0.hasDataForVersion(selectedVersion)
		}
	}
	private var filteredResourcesForMoveName: [PokemonMoveData] {
		if !searchText.isEmpty {
			return filteredResourcesForVersion.filter { $0.moveName.contains(searchText.lowercased()) }
		} else {
			return filteredResourcesForVersion
		}
	}
	private var orderedFilteredMoves: interMEdiateObject {
		
	}
//	private var orderedFilteredResources: [PokemonMoveData] {
//		switch ordering {
//			case .alphabetical:
//				return filteredResources.sorted {
//					$0.moveName < $1.moveName
//				}
//			case .default:
//				return filteredResources
//			case .level:
//				return filteredResources.sorted {
//					$0.minLevel < $1.minLevel
//				}
//			case .type:
//				return filteredResources.sorted {
//					$0.learnMethod.weight < $1.learnMethod.weight
//				}
//		}
//	}
	
	init(title: String,
		 resources: Binding<[PokemonMoveData]>) {
		self.title = title
		self._resources = resources
		self.selectedGen = genSet.sortedSet.first?.rawValue ?? VersionGroupName.redBlue.rawValue
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
			ForEach(orderedFilteredResources) { resource in
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
		.disableAutocorrection(true)
		.onAppear {
			selectedGen = genSet.sortedSet.first?.rawValue ?? "none"
		}
		.toolbar {
			HStack {
				Menu {
					Picker("", selection: $ordering) {
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
					Picker("", selection: $selectedGen) {
						ForEach(genSet.sortedSet, id: \.self) { gen in
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
