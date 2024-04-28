//
//  ChatManager.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class ChatManager {

    /// Messages sent from the user or received from OpenAI
    var messages = [ChatMessage]()

    /// Returns true if OpenAI is still streaming a response back to us
    var isProcessing: Bool {
        return self.streamTask != nil
    }

    /// Task that encapsulates OpenAI's streaming response.
    /// Cancel this to interrupt OpenAI's response.
    private var streamTask: Task<Void, Never>? = nil
    private let chatDataLoader = ChatDataLoader()

    /// Send a new message to OpenAI and start streaming OpenAI's response
    func send(message: ChatMessage) {
        self.messages.append(message)
        self.setupStreamingTask(withPrompt: message.text)
    }

    /// Stop the streaming response from OpenAI
    func stop() {
        self.streamTask?.cancel()
        self.streamTask = nil
    }

    private func setupStreamingTask(withPrompt prompt: String) {
        self.messages.append(ChatMessage(text: "", isUser: false, isWaitingForFirstText: true))
        self.streamTask = Task { [weak self] in
            guard let this = self else { return }
            do {
                let responseStream = try await this.chatDataLoader.addToConversation(prompt)
                for try await responseText in responseStream {
                    if var last = this.messages.popLast() {
                        last.isWaitingForFirstText = false
                        last.text += responseText
                        this.messages.append(last)
                    }
                }
                this.streamTask = nil
            } catch {
                AppLogger.error("Received an unexpected error from OpenAI streaming: \(error)")
            }
        }
    }
}
