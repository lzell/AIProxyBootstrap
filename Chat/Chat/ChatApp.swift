//
//  ChatApp.swift
//  Chat
//
//  Created by Lou Zell
//

import SwiftUI

@main
@MainActor
struct ChatApp: App {

    @State private var chatManager = ChatManager()

    var body: some Scene {
        WindowGroup {
            ChatView(chatManager: chatManager)
        }
    }
}
