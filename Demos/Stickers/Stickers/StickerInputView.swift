//
//  StickerInputView.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

/// The user enters a sticker prompt using this view.
struct StickerInputView: View {

    enum FocusedField {
        case currentPrompt
    }

    /// Bind to a UI model's property for that property to change as the user enters text,
    /// and for programmatic changes to the UI model's property to be reflected in this view
    @Binding var currentPrompt: String
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack(spacing:8){
            Text("Describe your sticker below")
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.28))
            TextField("type here...", text: $currentPrompt, axis: .vertical)
                .focused($focusedField, equals: .currentPrompt)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .textFieldStyle(.plain)
                .foregroundColor(.black.opacity(0.75))
                .onAppear {
                    focusedField = .currentPrompt
                }
        }
        .padding()
    }
}

