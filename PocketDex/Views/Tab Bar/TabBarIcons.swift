//
//  TabBarIcons.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/6/21.
//

import SwiftUI

struct TabBarIcons: View {
	@EnvironmentObject var viewRouter: ViewRouter
	
	var geometry: GeometryProxy
	
    var body: some View {
		HStack(spacing: 0) {
			ForEach(TabIcon.allCases, id: \.rawValue) {
				TabBarIcon(selection: $0)
					.frame(width: geometry.size.width / 5, height: geometry.size.height/10)
			}
		}
		.frame(width: geometry.size.width, height: geometry.size.height/10)
		.padding(.bottom)
		.background(Color.gray.shadow(radius: 2))
	}
}

struct TabBarIcons_Previews: PreviewProvider {
    static var previews: some View {
		GeometryReader { geometry in
			VStack {
				Spacer()
				
				TabBarIcons(geometry: geometry)
					.environmentObject(ViewRouter(initialSelection: .pokemon))
			}
			.edgesIgnoringSafeArea(.bottom)
		}
    }
}
