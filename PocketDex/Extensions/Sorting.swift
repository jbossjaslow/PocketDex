//
//  Sorting.swift
//  PocketDex
//
//  Created by Josh Jaslow on 10/16/21.
//

import Foundation

//struct SortDescriptor<Value: Comparable> {
//	var comparator: (Value, Value) -> ComparisonResult
//}
//
//enum SortOrder {
//	case ascending
//	case descending
//}
//
//extension Sequence {
//	func sorted<T: Comparable>(using descriptors: [SortDescriptor<T>],
//				order: SortOrder) -> [T] {
//		sorted { valueA, valueB in
//			for descriptor in descriptors {
//				let result = descriptor.comparator(valueA, valueB)
//				
//				switch result {
//					case .orderedSame:
//						// Keep iterating if the two elements are equal,
//						// since that'll let the next descriptor determine
//						// the sort order:
//						break
//					case .orderedAscending:
//						return order == .ascending
//					case .orderedDescending:
//						return order == .descending
//				}
//			}
//			
//			// If no descriptor was able to determine the sort
//			// order, we'll default to false (similar to when
//			// using the '<' operator with the built-in API):
//			return false
//		}
//	}
//	
//	func sorted(using descriptors: SortDescriptor<Element>...) -> [Element] {
//			sorted(using: descriptors,
//				   order: .ascending)
//		}
//}
