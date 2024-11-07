//
//  FilmFinderApp.swift
//  FilmFinder
//
//  Created by Todd Hamilton on 10/30/24.
//

import SwiftUI
import TipKit

@main
struct FilmFinderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        /// Load and configure the state of all the tips of the app
        try? Tips.configure()
    }
}
