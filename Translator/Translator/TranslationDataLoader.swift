//
//  Translator.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftOpenAI

private let prompt = "The response is an exact translation from english to spanish. You don't respond with any english."

/// Interfaces with OpenAI to translate input text from english to spanish
struct TranslationDataLoader {
    private init() {
        fatalError("Translator is a namespace only")
    }
    
    /// Translate `input` from english to spanish
    /// - Parameter input: the english input
    /// - Returns: the spanish translation
    static func run(on input: String) async -> String {

        let parameters = ChatCompletionParameters(
           messages: [
            .init(role: .system, content: .text(prompt)),
            .init(role: .user, content: .text(input)),
           ],
           model: .gpt41106Preview
        )
        do {
            let choices = try await AppConstants.openAI.startChat(parameters: parameters).choices
            let message = choices.compactMap(\.message.content)
            if let text = message.first {
                return text
            }
        } catch {
            AppLogger.error("Could not translate using gpt41106preview: \(error)")
        }
        return "Translation failed!"
    }
}
