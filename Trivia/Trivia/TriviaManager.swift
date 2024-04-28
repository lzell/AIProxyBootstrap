//
//  TriviaManager.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class TriviaManager {

    /// The topic of trivia
    let topic: String

    /// The number of cards for the user to solve
    let numCards: Int

    /// All trivia cards
    let triviaCards: [TriviaCardData]

    /// Observable of remaining cards that the user hasn't yet solved
    var remainingCards: [TriviaCardData] {
        return Array(self.triviaCards.suffix(from: self.currentCardIndex))
    }

    /// Number of questions that were answered correctly on the first guess
    var numCorrectOnFirstGuess: Int {
        return self.guessTracker.filter { $0.value == 1 }.count
    }

    private var currentCardIndex: Int
    private let triviaDataLoader: TriviaDataLoader

    /// Tracks number of guesses before the right answer was reached.
    /// The key is the the question, the value is the number of guesses
    private var guessTracker = [TriviaQuestionModel: Int]()

    /// Creates a UI model for the TriviaView view
    /// - Parameters:
    ///   - topic: The topic of trivia
    ///   - numCards: The number of cards to display in the UI
    init(topic: String, numCards: Int) {
        let triviaFetcher = TriviaDataLoader(topic: topic)
        self.topic = topic
        self.numCards = numCards
        self.currentCardIndex = 0
        self.triviaDataLoader = triviaFetcher
        self.triviaCards = (0..<numCards).map { i in TriviaCardData(triviaFetcher: triviaFetcher, position: i) }
        Task {
            await self.triviaCards[0].load()
        }
        self.loadNext()
    }

    /// Progress to the next trivia card
    func progress() {
        self.currentCardIndex += 1
        self.loadNext()
    }

    /// Increments the number of guesses for the question passed as argument
    func trackGuess(ofQuestion question: TriviaQuestionModel) {
        self.guessTracker[question, default: 0] += 1
    }

    private func loadNext() {
        if (self.currentCardIndex < self.numCards - 1) {
            Task {
                await self.triviaCards[self.currentCardIndex + 1].load()
            }
        }
    }

    deinit {
        AppLogger.debug("TriviaData is being freed")
    }
}
