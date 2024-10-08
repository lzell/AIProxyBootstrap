//
//  ChatDataLoader.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import AIProxy

enum ChatDataLoaderError: Error {
    case busy
}

/// Asynchronously sends prompts to OpenAI and streams back the response
final actor ChatDataLoader {
    private var streamingResponseAccumulator: String?

    /// All chat messages, including user queries and openai responses.
    /// The full history of the chat is sent with each request to openai to provide an ongoing conversation with memory.
    private var messages = [OpenAIChatCompletionMessage]()

    /// Add a user message to the conversation and stream back the openai response
    func addToConversation(_ prompt: String) async throws -> AsyncThrowingStream<String, Error> {
        guard streamingResponseAccumulator == nil else {
            throw ChatDataLoaderError.busy
        }
        self.streamingResponseAccumulator = ""
        
        self.messages.append((.user(content: .text(prompt))))
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o-mini",
            messages: [.user(content: .text(prompt))]
        )
        let stream = try await AppConstants.openAIService.streamingChatCompletionRequest(body: requestBody)

        return AsyncThrowingStream { continuation in
            let task = Task {
                for try await result in stream {
                    guard let choice = result.choices.first,
                          let content = choice.delta.content else
                    {
                        self.addAccumulatedResponseToMessageHistory()
                        continuation.finish()
                        return
                    }

                    self.addToResponseAccumulator(text: content)
                    continuation.yield(content)
                }
            }

            continuation.onTermination = { @Sendable termination in
                task.cancel()
                if case .cancelled = termination {
                    Task {
                        await self.addAccumulatedResponseToMessageHistory()
                    }
                }
            }
        }
    }


    private func addAccumulatedResponseToMessageHistory() {
        if let accumulator = self.streamingResponseAccumulator {
            self.messages.append(.assistant(content: .text(accumulator)))
            self.streamingResponseAccumulator = nil
        }
    }

    private func addToResponseAccumulator(text: String) {
        if let accumulator = self.streamingResponseAccumulator {
            self.streamingResponseAccumulator = accumulator + text
        } else {
            self.streamingResponseAccumulator = text
        }
    }
}
