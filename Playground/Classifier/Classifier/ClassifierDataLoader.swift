//
//  ClassifierDataLoader.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import UIKit
import RegexBuilder
import SwiftOpenAI

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
  
        let prompt = "What kind of plant is this and provide the wikipedia link for it, not in markdown"
        let messageContent: [ChatCompletionParameters.Message.ContentType.MessageContent] = [.text(prompt), .imageUrl(.init(url: localURL))]
        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .contentArray(messageContent))], model: .gpt4o)
        let response = try await AppConstants.openAI.startChat(parameters: parameters)

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
