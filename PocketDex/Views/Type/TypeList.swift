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
			if !makingRequest {
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
				.navigationBarHidden(true)
			} else {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.navigationBarHidden(true)
			}
		}
		.onAppear {
			requestTypes()
		}
	}
	
	func requestTypes() {
		makingRequest = true
		Type.requestList { (_ result: [NamedAPIResource<Type>]?) in
			DispatchQueue.main.async {
				guard let resourceList = result else {
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
