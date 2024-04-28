//
//  StickerView.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import SwiftUI

@MainActor
struct StickerView: View {
    @Environment(\.dismiss) private var dismiss

    /// The manager that drives this view
    @Bindable var stickerManager: StickerManager

    var body: some View {
        VStack{
            if let image = stickerManager.image {
                buildResultView(withUIImage: image)
            } else {
                promptView
            }
        } 
        .toolbar {
            stickerToolbar
        }
        .onAppear() {
            stickerManager.startOver()
        }
    }

    private func buildResultView(withUIImage uiImage: UIImage) -> some View {
        VStack(spacing:16) {
            VStack{
                StickerImageView(uiImage: uiImage)
                    .onTapGesture {
                        self.copyImage(uiImage: uiImage)
                    }
                Spacer()
                userMessageView
                Spacer()
            }
            .background(stickerManager.currentColor.gradient)
            .cornerRadius(17)
            startOverButton
            regenerateButton
        }
        .padding()
    }

    private var promptView: some View {
        VStack(spacing:16) {
            if stickerManager.isProcessing {
                StickerLoadingView()
                    .background(stickerManager.currentColor.gradient)
                    .cornerRadius(17)
            } else {
                StickerInputView(currentPrompt: $stickerManager.prompt)
                    .background(stickerManager.currentColor.gradient)
                    .cornerRadius(17)
                generateButton
            }
        }
        .padding()
    }

    private var stickerToolbar: some View {
        Button("Clear") {
            stickerManager.prompt = ""
        }
        .disabled(stickerManager.prompt.count == 0)
    }

    private var userMessageView: some View {
        Text(stickerManager.userMessage)
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .multilineTextAlignment(.center)
            .transition(.scale)
    }

    // MARK: - Actions

    /// Copy the passed `uiImage` to system clipboard
    private func copyImage(uiImage: UIImage) {
        UIPasteboard.general.image = uiImage
        stickerManager.flashUserMessage("Copied!")
    }

    // MARK: - Buttons

    /// Button to start from the prompt input view and dispose of the existing sticker
    private var startOverButton: some View {
        Button {
            withAnimation {
                stickerManager.startOver()
            }
        } label: {
            Label("Start Over", systemImage: "sparkles")
                .frame(maxWidth:.infinity)
        }
        .buttonStyle(ChunkyButtonStyle())
    }
    
    /// Button to regenerate a sticker from the current prompt, disposing of the existing sticker.
    private var regenerateButton: some View {
        Button{
            withAnimation{
                stickerManager.regenerate()
            }
        }label:{
            Label("Regenerate", systemImage: "arrow.triangle.2.circlepath")
                .frame(maxWidth:.infinity)
        }
        .buttonStyle(ChunkyButtonStyle())
    }

    /// Button to generate a sticker from the current user prompt
    private var generateButton: some View {
        Button {
            withAnimation() {
                stickerManager.createSticker()
            }
        } label: {
            Label("Generate", systemImage: "sparkles")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ChunkyButtonStyle())
    }
}

#Preview {
    StickerView(stickerManager: StickerManager())
}
