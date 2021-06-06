//
//  TabBar.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/5/21.
//

import SwiftUI
import PokeSwift

struct TabBar: View {
	@EnvironmentObject var viewRouter: ViewRouter
	
	var body: some View {
		GeometryReader { geometry in
			VStack(spacing: 0) {
				TabBarView()
				
				TabBarIcons(geometry: geometry)
			}
			.edgesIgnoringSafeArea(.bottom)
		}
	}
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
			.environmentObject(ViewRouter(initialSelection: .pokemon))
    }
}
