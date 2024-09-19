//
//  Translator.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation

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
        do {
            let response = try await AppConstants.openAIService.chatCompletionRequest(body: .init(
                model: "gpt-4o",
                messages: [
                    .system(content: .text(prompt)),
                    .user(content: .text(input))
                ]
            ))
            if let text = response.choices.first?.message.content {
                return text
            }
        } catch {
            AppLogger.error("Could not translate using gpt4o: \(error)")
        }
        return "Translation failed!"
    }
}
