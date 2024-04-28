//
//  ChatInputView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

/// A view for the user to enter chat messages
struct ChatInputView: View {

    private enum FocusedField {
        case newMessageText
    }

    /// Is a streaming chat response in progress
    let isStreamingResponse: Bool

    /// Callback invoked when the user taps the submit button or presses return
    var didSubmit: (String) -> Void

    /// Callback invoked when the user taps on the stop button
    var didTapStop: () -> Void

    /// State to collect new text messages
    @State private var newMessageText: String = ""
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        HStack(spacing:0){
            chatInputTextField
            actionButton
        }
        .padding(8)
    }

    private var chatInputTextField: some View {
        TextField("Type a message", text: $newMessageText, axis: .vertical)
            .focused($focusedField, equals: .newMessageText)
            .lineLimit(5)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius:30)
                    .fill(Color(.tertiarySystemGroupedBackground))
                    .stroke(.separator)
            )
            .onAppear {
                focusedField = .newMessageText
            }
            .onSubmit {
                didSubmit(newMessageText)
                newMessageText = ""
            }
    }

    private var actionButton: some View {
        Button {
            if isStreamingResponse {
                didTapStop()
            } else {
                didSubmit(newMessageText)
                newMessageText = ""
            }
        } label:{
            Image(systemName: isStreamingResponse ? "stop.circle.fill" : "arrow.up.circle.fill")
                .font(.title)
                .foregroundColor((isStreamingResponse || !newMessageText.isEmpty) ? .primary : .secondary)
                .frame(width:40, height:40)
        }
        .contentTransition(.symbolEffect(.replace))
        .padding(.horizontal, 8)
    }
}

#Preview {
    ChatInputView(isStreamingResponse: false, didSubmit: { _ in }, didTapStop: { })
}
