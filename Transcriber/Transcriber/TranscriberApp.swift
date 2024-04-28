//
//  TranscriberApp.swift
//  Transcriber
//
//  Created by Lou Zell
//

import SwiftUI

@main
@MainActor
struct TranscriberApp: App {

    @State var transcriberManager = TranscriberManager()

    var body: some Scene {
        WindowGroup {
            TranscriberView(transcriberManager: transcriberManager)
        }
    }
}
