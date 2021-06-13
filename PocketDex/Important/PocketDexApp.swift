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
    var body: some Scene {
        WindowGroup {
			TabBar()
//				.environmentObject(ViewRouter(initialSelection: .pokemon))
        }
    }
}
