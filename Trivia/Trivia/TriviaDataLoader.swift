//
//  TriviaFetcher.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftOpenAI

// It's important to add the 'produce JSON' instruction to the system prompt.
// See the note at https://platform.openai.com/docs/api-reference/chat/create#chat-create-response_format
private let prompt = """
You are a trivia bot that produces JSON. You ask hard questions with four possible answers. Specifying the index of the correct answer in the key `correct_answer_index`. Example response:
{ question: "xyz", answers: ["a", "b", "c", "d"], correct_answer_index: 2 }
"""

/// Loads trivia data from openai
final actor TriviaDataLoader {
    /// The topic of trivia
    let topic: String

    /// Create the TriviaDataLoader responsible for fetching trivia data from OpenAI
    /// - Parameter topic: The topic of trivia
    init(topic: String) {
        self.topic = topic
    }

    /// We store past questions, and send them back to openai on subsequent requests.
    /// This prevents chat from asking the same questions
    private var pastQuestions = [String]()

    deinit {
        AppLogger.debug("TriviaFetcher is being freed")
    }


    /// Fetches the next trivia question from OpenAI over the network
    /// - Returns: A TriviaQuestionModel containing one question and multiple choice answers
    func getNextQuestion() async throws -> TriviaQuestionModel {
        var messages = prompt
        if self.pastQuestions.count > 0 {
            let pastQuestionsList = self.pastQuestions.joined(separator: "\n\n")
            messages += "\nDo not repeat any of these questions: \(pastQuestionsList)"
        }

        let parameters = ChatCompletionParameters(
           messages: [
            .init(role: .user, content: .text("Ask me a question about: \(topic)")),
            .init(role: .system, content: .text(messages))
           ],
           model: .gpt41106Preview, // .gpt35Turbo1106 also works, and is faster, but duplicates questions.
           responseFormat: ChatCompletionParameters.ResponseFormat.init(type: "json_object")
        )

        let choices = try await AppConstants.openAI.startChat(parameters: parameters).choices
        guard let text = choices.first?.message.content else {
            throw TriviaFetcherError.couldNotFetchQuestion
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        AppLogger.info("Received from openai: \(text)")
        let model = try decoder.decode(TriviaQuestionModel.self, from: text.data(using: .utf8)!)
        self.pastQuestions.append(model.question)
        return model
    }
}

enum TriviaFetcherError: Error {
    case couldNotFetchQuestion
}

struct TriviaQuestionModel: Decodable, Hashable {

    struct LabeledAnswer: Identifiable {
        let id = UUID()
        let text: String
    }

    let question: String
    let answers: [String]
    let correctAnswerIndex: Int

    var labeledAnswers: [LabeledAnswer] {
        return zip(["A", "B", "C", "D"], self.answers).map {
            LabeledAnswer(text: "\($0). \($1)")
        }
    }
}
