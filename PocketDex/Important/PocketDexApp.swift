//
//  PocketDexApp.swift
//  PocketDex
//
//  Created by Josh Jaslow on 5/2/21.
//

import SwiftUI
import PokeSwift

@main
struct PocketDexApp: App {
	
	init() {
//		UINavigationBar.appearance().isTranslucent = false
//		let largeTitleAppearance = UINavigationBarAppearance()
//		largeTitleAppearance.configureWithTransparentBackground()
//		let largeTitleAttrs: [NSAttributedString.Key: Any] = [
//			.foregroundColor: UIColor.black,
//			.font: UIFont.monospacedSystemFont(ofSize: 36, weight: .black)
//		]
//		largeTitleAppearance.largeTitleTextAttributes = largeTitleAttrs
//		UINavigationBar.appearance().scrollEdgeAppearance = largeTitleAppearance
//		
//		let inlineAppearance = UINavigationBarAppearance()
//		inlineAppearance.configureWithDefaultBackground()
//		inlineAppearance.backgroundEffect = UIBlurEffect(style: .light)
//		let inlineTitleAttrs: [NSAttributedString.Key: Any] = [
//			.foregroundColor: UIColor.black,
//			.font: UIFont.monospacedSystemFont(ofSize: 26, weight: .regular)
//		]
//		inlineAppearance.titleTextAttributes = inlineTitleAttrs
//		UINavigationBar.appearance().standardAppearance = inlineAppearance
	}
	
    var body: some Scene {
        WindowGroup {
			TabBar()
//				.environmentObject(ViewRouter(initialSelection: .pokemon))
        }
    }
}
