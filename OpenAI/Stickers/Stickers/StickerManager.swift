//
//  StickerManager.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import UIKit
import SwiftUI

/// The default message to display in the result view of the sticker experience.
private let defaultUserMessage = "Tap on the image to copy to your clipboard."

@MainActor
@Observable
final class StickerManager {

    /// The user-entered prompt
    var prompt: String = ""

    /// The current background color to use for the view
    var currentColor: Color = .teal

    /// The generated sticker as a UIImage
    private(set) var image: UIImage?

    /// A flag to indicate that the sticker is being generated and we are waiting on I/O from OpenAI
    private(set) var isProcessing = false

    /// The user message to display along with the generated sticker
    private(set) var userMessage = defaultUserMessage

    /// The set of potential background colors for the view
    private var bgColors: Set<Color> = [.teal, .mint, .indigo, .red, .pink, .purple, .orange, .brown, .blue, .cyan, .green, .yellow, .gray]

    /// A few examples to get the user's wheels turning
    private let placeholderExamples = [
        "a cactus wearing a sombrero...",
        "a hedgehog riding a motorcycle...",
        "a kangaroo holding a basketball..."
    ]
    private var placeholderIndex = 0

    private let stickerDataLoader = StickerDataLoader()

    /// Changes the user message briefly away from the default text.
    /// After two seconds, the user message reverts to the default message
    func flashUserMessage(_ message: String) {
        withAnimation(.bouncy) {
            userMessage = message
        }
        Task { [weak self] in
            try await Task.sleep(for: .seconds(2))
            withAnimation(.bouncy) { [weak self] in
                self?.userMessage = defaultUserMessage
           }
        }
    }

    /// Creates a sticker from the current prompt stored in `self.prompt`
    func createSticker() {
        guard !self.isProcessing else {
            AppLogger.info("Already creating a sticker. Please wait")
            return
        }

        let prompt = self.prompt
        guard prompt.count > 0 else {
            AppLogger.error("Trying to submit a sticker without a prompt. This is a programmer error")
            return
        }

        self.isProcessing = true
        Task {
            self.image = try await stickerDataLoader.create(fromPrompt: prompt)
            self.isProcessing = false
        }
    }

    /// Change the placeholder prompt
    func nextPlaceholder() {
        self.placeholderIndex = (self.placeholderIndex + 1) % self.placeholderExamples.count
        self.prompt = self.placeholderExamples[self.placeholderIndex]
    }

    /// Returns to the starting point of the sticker experience, e.g. where no sticker is in the UI
    func startOver() {
        self.image = nil
        self.nextPlaceholder()
        self.currentColor = self.bgColors.randomElement()!
    }

    /// Regenerate a sticker using the same prompt
    func regenerate() {
        self.image = nil
        self.createSticker()
        self.currentColor = self.bgColors.randomElement()!
    }
}

