//
//  DynamicListProvider.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/2/21.
//

import Foundation
import PokeSwift

class DynamicListProvider<ResourceType: Requestable>: ObservableObject {
	@Published var resourceList: [NamedAPIResource<ResourceType>]
	@Published var fetchingResources: Bool = false
	
	private let batchSize: Int
	private let prefetchMargin: Int
	
	private var nextBatchURL: String? = nil
	
	init(batchSize: Int = 20,
		 prefetchMargin: Int = 3) {
		resourceList = []
		self.batchSize = batchSize
		self.prefetchMargin = prefetchMargin
		fetchMoreItemsIfNeeded(currentIndex: 0)
	}
	
	func reset() {
		resourceList = []
		fetchMoreItemsIfNeeded(currentIndex: -1)
	}
	
	func fetchMoreItemsIfNeeded(currentIndex: Int) {
		guard !fetchingResources,
			  currentIndex >= resourceList.count - prefetchMargin else { return }
		
		fetchingResources = true
		print("Fetching with index \(currentIndex)")
		
		if let nextBatchURL = nextBatchURL {
			ResourceType.requestList(from: nextBatchURL) { (_ pagedList: PagedList<ResourceType>?) in
				DispatchQueue.main.async {
					self.fetchingResources = false
					print("Fetching from next url")
					self.handleFetch(pagedList: pagedList)
				}
			}
		} else {
			let startIndex = resourceList.count
			ResourceType.requestList(resourceLimit: batchSize,
									 offset: startIndex) { (_ pagedList: PagedList<ResourceType>?) in
				DispatchQueue.main.async {
					self.fetchingResources = false
					print("Fetching from discrete URL")
					self.handleFetch(pagedList: pagedList)
				}
			}
		}
	}
	
	private func handleFetch(pagedList: PagedList<ResourceType>?) {
		guard let fetchedList = pagedList else {
			return
		}
		self.nextBatchURL = fetchedList.next
		self.resourceList.append(contentsOf: fetchedList.results)
	}
}
