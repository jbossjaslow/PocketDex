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
	}
	
	func reset() async {
		resourceList = []
		await fetchMoreItemsIfNeeded(currentIndex: -1)
	}
	
	func fetchMoreItemsIfNeeded(currentIndex: Int) async {
		guard !fetchingResources,
			  currentIndex >= resourceList.count - prefetchMargin else { return }
		
		fetchingResources = true
		print("Fetching with index \(currentIndex)")
		
		do {
			if let nextBatchURL = nextBatchURL {
				let pagedList: PagedList<ResourceType> = try await ResourceType.requestList(from: nextBatchURL)
				self.handleFetch(pagedList: pagedList)
				print("Fetching from next url")
			} else {
				let startIndex = resourceList.count
				let pagedList: PagedList<ResourceType> = try await ResourceType.requestDynamicList(resourceLimit: batchSize,
																								   offset: startIndex)
				self.handleFetch(pagedList: pagedList)
				print("Fetching from discrete URL")
			}
		} catch {
			print("ERROR: \(error.localizedDescription)")
		}
		
		self.fetchingResources = false
	}
	
	private func handleFetch(pagedList: PagedList<ResourceType>?) {
		guard let fetchedList = pagedList else {
			return
		}
		self.nextBatchURL = fetchedList.next
		self.resourceList.append(contentsOf: fetchedList.results)
	}
}
