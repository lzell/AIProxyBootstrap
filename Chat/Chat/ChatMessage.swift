//
//  ChatMessage.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation

/// Data model to represent a chat message
struct ChatMessage: Identifiable, Equatable {
    /// Unique identifier
    let id = UUID()

    /// The body of the chat message
    var text: String

    /// True if the message originates from the user, false if it originates from OpenAI
    let isUser: Bool

    /// Indicates that we are waiting for the first bit of message content from OpenAI
    var isWaitingForFirstText = false
}
