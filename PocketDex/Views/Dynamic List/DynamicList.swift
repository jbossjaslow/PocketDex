//
//  DynamicList.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/31/21.
//

import SwiftUI
import PokeSwift

protocol ListDataItem {
	var index: Int { get set }
	init(index: Int)
	
	/// Fetch additional data of the item, possibly asynchronously
	func fetchData()
	
	/// Has the data been fetched?
	var isFetched: Bool { get }
}

/// Generic data provider for the list
class ListDataProvider<Item: ListDataItem>: ObservableObject {
	/// - Parameters:
	///   - itemBatchCount: Number of items to fetch in each batch. It is recommended to be greater than number of rows displayed.
	///   - prefetchMargin: How far in advance should the next batch be fetched? Greater number means more eager.
	///                     Should be less than temBatchSize.
	init(itemBatchCount: Int = 20, prefetchMargin: Int = 3) {
		itemBatchSize = itemBatchCount
		self.prefetchMargin = prefetchMargin
		reset()
	}
	
	private let itemBatchSize: Int
	private let prefetchMargin: Int
	
	private(set) var listID: UUID = UUID()
	
	func reset() {
		list = []
		listID = UUID()
		fetchMoreItemsIfNeeded(currentIndex: -1)
	}
	@Published var list: [Item] = []
	
	/// Extend the list if we are close to the end, based on the specified index
	func fetchMoreItemsIfNeeded(currentIndex: Int) {
		guard currentIndex >= list.count - prefetchMargin else { return }
		let startIndex = list.count
		
//		for currentIndex in startIndex ..< max(startIndex + itemBatchSize, currentIndex) {
//			list.append(Item(index: currentIndex))
//			list[currentIndex].fetchData()
//		}
	}
}

final class PSListDataItem<ResourceType: Requestable>: ListDataItem, ObservableObject {
	var index: Int
	
	init(index: Int) {
		self.index = index
		self.isFetched = false
	}
	
	func fetchData() -> PagedL {
		<#code#>
		isFetched = true
	}
	
	@Published var isFetched: Bool
//	@Published var namedResource: NamedAPIResource<ResourceType>
}

/// The view for the list row
protocol DynamicListRow: View {
	associatedtype Item: ListDataItem
	var item: Item { get }
	init(item: Item)
}

// Usage: var listProvider = ListDataProvider<MyDataItem>(itemBatchCount: 20, prefetchMargin: 3)
// DynamicList<MyListRow>(listProvider: listProvider)
/// The view for the dynamic list
struct DynamicList<Row: DynamicListRow>: View {
	@ObservedObject var listProvider: ListDataProvider<Row.Item>
	
	var body: some View {
		List(0 ..< listProvider.list.count, id: \.self) { index in
			Row(item: self.listProvider.list[index])
				.onAppear {
					self.listProvider.fetchMoreItemsIfNeeded(currentIndex: index)
				}
		}
		.id(self.listProvider.listID)
	}
}

struct PaginatedListRow<ResourceType: BaseResourceProtocol>: DynamicListRow {
	typealias Item = PSListDataItem<ResourceType>
	@State var item: Item
	
	init(item: Item) {
		self.item = item
	}
	
	var body: some View {
		NavigationLink(destination: Text("Hello World")) {
			item.
		}
	}
}
