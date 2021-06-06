//
//  TabBarIcon.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/6/21.
//

import SwiftUI

struct TabBarIcon: View {
	@EnvironmentObject var viewRouter: ViewRouter
	
	@State var selection: TabIcon
	
	var body: some View {
		GeometryReader { geometry in
		VStack {
			Image(uiImage: viewRouter.getTabIcon(selection))
				.resizable()
				.aspectRatio(contentMode: .fit)
				.saturation(viewRouter.currentSelection == selection ? 1 : 0)
				.frame(width: geometry.size.height * 0.5, height: geometry.size.height * 0.5)
				.padding(.top, 10)
			
			Text(selection.rawValue)
				.font(.footnote)
				.frame(width: geometry.size.width, height: geometry.size.height * 0.2)
			
			Spacer()
		}
		.onTapGesture {
			viewRouter.currentSelection = selection
		}
		}
	}
}

struct TabBarIcon_Previews: PreviewProvider {
	static var previews: some View {
		TabBarIcon(selection: .type)
			.environmentObject(ViewRouter(initialSelection: .pokemon))
	}
}
