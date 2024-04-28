//
//  ClassifierDataLoader.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import UIKit
import RegexBuilder

enum ClassifierDataLoaderError: Error {
    case couldNotCreateImageURL
    case couldNotIdentifyPlant
}


/// Sends requests to OpenAI to classify plant images, and returns the result asynchronously
final actor ClassifierDataLoader {

    /// Uses OpenAI to fetch a description of the image passed as argument
    /// - Parameter image: The image to describe
    /// - Returns: An OpenAI description of the image
    func identify(fromImage image: CGImage) async throws -> (String, URL?) {

        guard let localURL = image.openAILocalURLEncoding() else {
            throw ClassifierDataLoaderError.couldNotCreateImageURL
        }

        let content: [AIProxy.Message.ContentType.MessageContent] = [
            .text("Juanjo put your user prompt here"),
            .imageUrl(localURL)
        ]

        let requestBody = AIProxy.ChatRequestBody(
            model: "gpt-4-vision-preview",
            messages: [
                .init(role: "user", content: .contentArray(content)),
                .init(role: "system", content: .text("Juanjo put your system prompt here"))
               ],
            maxTokens: 300
        )

        let response = try await AIProxy.chatCompletionRequest(
            chatRequestBody: requestBody
        )

        // Do something with response.choices, e.g.
        print(response.choices.first?.message.content)

        let choices = response.choices
        guard let text = choices.first?.message.content else {
            throw ClassifierDataLoaderError.couldNotIdentifyPlant
        }

        return extractDescriptionAndWikipediaURL(text)
    }
}


// Assumes that the wikipedia link as at the end of input `text`
private func extractDescriptionAndWikipediaURL(_ text: String) -> (String, URL?) {
    var mutableText = text
    let re = Regex {
        TryCapture {
           /https?:\/\/[^.]*\.wikipedia\.org[^\b]+$/
        } transform: {
            URL(string: String($0))
        }
    }

    var matchingURL: URL? = nil
    mutableText.replace(re, maxReplacements: 1) { matchingURL = $0.1; return "" }
    return (mutableText, matchingURL)
}

private extension CGImage {
    func openAILocalURLEncoding() -> URL? {
        if let data = UIImage(cgImage: self).jpegData(compressionQuality: 0.4) {
            let base64String = data.base64EncodedString()
            if let url = URL(string: "data:image/jpeg;base64,\(base64String)") {
                return url
            }
        }
        return nil
    }
}
