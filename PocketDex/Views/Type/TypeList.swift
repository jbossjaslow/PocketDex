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
			} else {
				Text("Loading...")
			}
		}
		.loadingResource(isLoading: $makingRequest)
		.onAppear {
			print("Appearing")
			requestTypes()
		}
	}
	
	func requestTypes() {
		makingRequest = true
		Type.requestStaticList(resourceLimit: Type.normalLimit) { (_ result: PagedList<Type>?) in
			DispatchQueue.main.async {
				guard let resourceList = result?.results else {
					self.makingRequest = false
					return
				}
				
				self.typeMapList = resourceList.compactMap {
					switch $0.name {
						case "unknown", "shadow":
							return nil
						default:
							return Type.mapAdditionalInfo($0.name)
					}
				}
				self.makingRequest = false
			}
		}
	}
}

struct TypeList_Previews: PreviewProvider {
	static var previews: some View {
		TypeList()
	}
}
