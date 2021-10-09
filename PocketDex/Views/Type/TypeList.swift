//
//  TypeList.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/16/21.
//

import SwiftUI
import PokeSwift

struct TypeList: View {
	@State var typeMapList: [TypeMap] = []
	@State var makingRequest: Bool = false
	
	var body: some View {
		NavigationView {
			if !makingRequest && !typeMapList.isEmpty {
				List {
					ForEach(typeMapList) { typeMap in
						NavigationLink(
							destination: TypeDetail().environmentObject(TypeViewModel(typeMap: typeMap))) {
							Image(uiImage: typeMap.iconRectangular)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding(.horizontal)
						}
					}
				}
				.navigationTitle("Types")
				.listStyle(PlainListStyle())
			} else {
				Text("Loading...")
			}
		}
//		.loadingResource(isLoading: $makingRequest)
		.task {
			await requestTypes()
		}
		.onAppear {
			print("Appearing")
		}
	}
	
	@MainActor
	func requestTypes() async {
		makingRequest = true
		defer { makingRequest = false }
		do {
			let pagedList: PagedList<Type> = try await Type.requestStaticList(resourceLimit: Type.normalLimit)
			let resourceList = pagedList.results
			self.typeMapList = resourceList.compactMap {
				switch $0.name {
					case "unknown", "shadow":
						return nil
					default:
						return Type.mapAdditionalInfo($0.name)
				}
			}
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
	}
}

struct TypeList_Previews: PreviewProvider {
	static var previews: some View {
		TypeList()
	}
}
