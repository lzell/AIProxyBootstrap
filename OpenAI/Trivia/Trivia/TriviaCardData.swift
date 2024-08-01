//
//  TriviaQuestion.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

@MainActor
@Observable
/// UI model for TriviaCardView
final class TriviaCardData: Identifiable {

    /// Position of the card, with 0 meaning that the card is on top and 1 meaning directly below the top card, etc.
    let position: Int

    /// Data model for the card contents
    var triviaQuestionModel: TriviaQuestionModel?

    /// Networker to load card contents from OpenAI
    private let triviaFetcher: TriviaDataLoader

    /// Creates a UI model for TriviaCardView
    /// - Parameters:
    ///   - triviaFetcher: Loads card contents from OpenAI
    ///   - position: Position of the card, with 0 being the top of the stack
    init(triviaFetcher: TriviaDataLoader, position: Int) {
        self.triviaFetcher = triviaFetcher
        self.position = position
    }

    /// Loads the trivia question's data model asynchronously
    func load() async {
        self.triviaQuestionModel = try! await self.triviaFetcher.getNextQuestion()
    }
}
