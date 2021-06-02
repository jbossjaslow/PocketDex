//
//  DynamicList.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/31/21.
//

import SwiftUI
import PokeSwift

struct DynamicList<T: Requestable>: View {
	@ObservedObject var listProvider: DynamicListProvider<T>
	
	init() {
		listProvider = DynamicListProvider(batchSize: 20,
										   prefetchMargin: 3)
	}
	
	var body: some View {
		List {
			ForEach(0 ..< listProvider.resourceList.count, id: \.self) { index in
				Button {
					print(listProvider.resourceList[index].name)
				} label: {
					HStack {
						Text(listProvider.resourceList[index].name)
//							.foregroundColor(.white)
						
						Spacer()
					}
//					.frame(height: 30)
//					.padding()
//					.background(Color.gray)
				}
				.onAppear {
					listProvider.fetchMoreItemsIfNeeded(currentIndex: index)
				}
			}
		}
	}
}

struct DynamicList_Previews: PreviewProvider {
	static var previews: some View {
		DynamicList<Type>()
	}
}
