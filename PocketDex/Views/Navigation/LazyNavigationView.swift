//
//  LazyNavigationView.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/6/21.
//

import SwiftUI

struct LazyNavigationView<Content: View>: View {
	let build: () -> Content
	init(_ build: @autoclosure @escaping () -> Content) {
		self.build = build
	}
	var body: Content {
		build()
	}
}

struct LazyNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        LazyNavigationView(Text("Hello World"))
    }
}
