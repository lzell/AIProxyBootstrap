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
    private var messages = [ChatCompletionParameters.Message]()

    /// Add a user message to the conversation and stream back the openai response
    func addToConversation(_ prompt: String) async throws -> AsyncThrowingStream<String, Error> {
        guard streamingResponseAccumulator == nil else {
            throw ChatDataLoaderError.busy
        }
        self.streamingResponseAccumulator = ""
        
        // SwiftOpenAICode
        self.messages.append(.init(role: .user, content: .text(prompt)))
//        let parameters = ChatCompletionParameters(
//            messages: self.messages,
//            model: .gpt4o
//        )
//        let stream = try await AppConstants.openAI.startStreamedChat(parameters: parameters)
        
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o-mini",
            messages: [.user(content: .text(prompt))]
        )
        let stream = try await AppConstants.openAIService.streamingChatCompletionRequest(body: requestBody)
        for try await chunk in stream {
            print(chunk.choices.first?.delta.content ?? "")
        }

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
            self.messages.append(.init(role: .assistant, content: .text(accumulator)))
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
