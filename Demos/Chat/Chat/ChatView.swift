//
//  ChatView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

@MainActor
struct ChatView: View {

    private enum ScrollChange {
        case userInteraction
        case programmatic
    }

    /// The chat manager that controls communication with OpenAI
    let chatManager: ChatManager

    /// Should we auto-scroll the scrollview as message content arrives
    @State private var isTrackingScrollView = false

    /// As the scroll position changes, this state indicates whether the change originated from a user interation or programmatically
    @State private var scrollChange: ScrollChange = .userInteraction

    /// The user's scroll position of the content view (e.g. where in the chat message contents they are positioned)
    @State private var scrollPosition: CGPoint = .zero {
        didSet {
            switch scrollChange {
            case .userInteraction:
                isTrackingScrollView = false
            case .programmatic:
                scrollChange = .userInteraction
            }
        }
    }

    /// The height of the scroll view (e.g. the frame's height)
    @State private var scrollViewHeight: CGFloat = .infinity

    /// The height of the contents contained within the scroll view
    @State private var scrollViewContentHeight: CGFloat = .zero

    @State private var scrollTrigger = false

    var body: some View {
        VStack {
            autoScrollingChatView
                .padding([.top, .leading, .trailing])

            ZStack(alignment: .top) {

                AutoScrollButton(isVisible: !isTrackingScrollView && scrollViewContentHeight > scrollViewHeight) {
                    isTrackingScrollView = true
                    scrollTrigger.toggle()
                }
                .offset(y: -50)

                ChatInputView(isStreamingResponse: chatManager.isProcessing,
                              didSubmit: { sendMessage($0) },
                              didTapStop: { chatManager.stop() })
            }
        }
    }

    private var autoScrollingChatView: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical) {
                ChatMessagesView(chatMessages: chatManager.messages)
                    .id("MessagesView")
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: geometry.frame(in: .named("chatScrollView")).origin)
                            .preference(key: ScrollHeightPreferenceKey.self,
                                        value: geometry.size.height)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollPosition = value
                    }
                    .onPreferenceChange(ScrollHeightPreferenceKey.self) { value in
                        scrollViewContentHeight = value
                    }
            }
            .coordinateSpace(name: "chatScrollView")
            .background(
                GeometryReader { outerScrollViewGeometry in
                    Color.clear
                        .preference(key: ScrollHeightPreferenceKey.self,
                                    value: outerScrollViewGeometry.size.height)
                }
            )
            .onPreferenceChange(ScrollHeightPreferenceKey.self) { value in
                scrollViewHeight = value
            }
            .onChange(of: scrollTrigger) {
                scrollChange = .programmatic
                scrollView.scrollTo("MessagesView", anchor: .bottom)
            }
            .onChange(of: chatManager.messages) { _, _ in
                if isTrackingScrollView {
                    scrollTrigger.toggle()
                }
            }
        }
    }

    private func sendMessage(_ message: String) {
        guard !message.isEmpty else { return }
        chatManager.send(message: ChatMessage(text: message, isUser: true))
    }
}

private struct ChatMessagesView: View {
    /// Flags to prevent messages from animating in multiple times as dependencies that drive `body` change
    @State private var shouldAnimateMessageIn = [UUID: Bool]()
    let chatMessages: [ChatMessage]

    var body: some View {
        VStack(alignment: .leading) {
            ChatBubble(message: ChatMessage(text: "How can I help you?", isUser: false), animateIn: true)
                .listRowSeparator(.hidden)

            ForEach(chatMessages) { message in
                ChatBubble(message: message, animateIn: shouldAnimateMessageIn[message.id] ?? true)
                    .listRowSeparator(.hidden)
                    .transition(.opacity)
                    .onAppear {
                        shouldAnimateMessageIn[message.id] = false
                    }
            }
        }
    }
}


// Credit: https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

private struct ScrollHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

private struct AutoScrollButton: View {
    let isVisible: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "arrowshape.down.fill")
                .font(.body)
                .foregroundColor(.primary)
                .padding(8)
        }
        .background(
            Circle()
                .fill(Color(.secondarySystemBackground))
                .stroke(.primary.opacity(0.1), lineWidth:1)
        ).shadow(color:.primary.opacity(0.14), radius: 3, x:0, y:2)
        .opacity(isVisible ? 1 : 0)
    }

}

#Preview {
    ChatView(chatManager: ChatManager())
}
