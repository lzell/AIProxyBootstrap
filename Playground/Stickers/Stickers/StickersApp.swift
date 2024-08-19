//
//  StickersApp.swift
//  Stickers
//
//  Created by Lou Zell
//

import SwiftUI

@main
@MainActor
struct StickersApp: App {

    @State var stickerManager = StickerManager()

    var body: some Scene {
        WindowGroup {
            StickerView(stickerManager: stickerManager)
        }
    }
}
