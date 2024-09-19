//
//  ChatBubbleView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

/// A view to contain a single message from either the user or OpenAI.
struct ChatBubble: View {

    /// The message to display
    let message: ChatMessage

    /// Whether to animate in the chat bubble
    let animateIn: Bool

    /// State used to animate in the chat bubble if `animateIn` is true
    @State private var animationTrigger = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            chatIcon
            VStack(alignment: .leading) {
                chatName
                chatBody
            }
        }
        .opacity(bubbleOpacity)
        .animation(.easeIn(duration: 0.75), value: animationTrigger)
        .onAppear {
            adjustAnimationTriggerIfNecessary()
        }
    }

    private var bubbleOpacity: Double {
        guard animateIn else {
            return 1
        }
        return animationTrigger ? 1 : 0
    }

    private func adjustAnimationTriggerIfNecessary() {
        guard animateIn else {
            return
        }
        animationTrigger = true
    }

    private var chatIcon: some View {
        Image(systemName: message.isUser ? "person.circle.fill" : "command.circle.fill")
            .font(.title2)
            .frame(width:24, height:24)
            .foregroundColor(message.isUser ? .primary : .teal)
    }

    private var chatName: some View {
        Text(message.isUser ? "You" : "ChatGPT")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight:24, alignment: .leading)
    }

    @ViewBuilder
    private var chatBody: some View {
        if message.isUser {
            Text(LocalizedStringKey(message.text))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.primary)
        } else {
            if message.isWaitingForFirstText {
                ProgressView()
            } else {
                Text(LocalizedStringKey(message.text))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    ChatBubble(message: ChatMessage(text: "hello", isUser: false), animateIn: false)
        .frame(maxWidth:.infinity)
        .padding()
}
