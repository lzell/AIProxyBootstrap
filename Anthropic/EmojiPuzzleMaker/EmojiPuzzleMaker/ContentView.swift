//
//  ContentView.swift
//  EmojiPuzzleMaker
//
//  Created by Todd Hamilton on 8/1/24.
//

import AIProxy
import SwiftUI
import WebKit
import Foundation

// Visit http://airoxy.pro to get a new partial key and DeviceCheck bypass token.
//
// See the README at https://github.com/lzell/AIProxySwift for instructions on
// adding a DeviceCheck bypass token as an environment variable (which is required
// for AIProxy to work in the iOS simulator)
#warning("You must replace the placeholder below")
let service = AIProxy.anthropicService(
    partialKey: "hardcode_partial_key_here",
    serviceURL: "hardcode_service_url_here"
)

struct ContentView: View {

    @State var emojis = "🏔️💦"
    @State var hint = "A fizzy green beverage"
    @State var prompt = ""
    @State var color = "blue"
    @State var json = ""
    let instructions = """
    You are an AI tasked with generating a fun and interesting emoji puzzle based on a given word or phrase. Your goal is to create a puzzle using 2-3 emojis that represent the word or phrase, along with a hint to help solve the puzzle. Follow these guidelines:
    
    1. Analyze the given word or phrase and think of relevant emojis that can represent it.
    2. Choose 2-3 emojis that, when combined, cleverly represent the word or phrase.
    3. Ensure the emojis are not too obvious, but also not impossibly difficult to decipher.
    4. Create a short, helpful hint that gives a clue about the word or phrase without directly stating it.
    5. Choose a SwiftUI color to match the theme of the puzzle.
    6. Your returned message content should only be valid JSON. Do not introduce the JSON with "Here is my emoji puzzle response" or any other introduction.
    7. In the JSON for `emojis` field, always put a space between unicode characters
    
    Generate a hint text that provides a subtle clue about the word or phrase without giving it away completely. The hint should be concise and engaging, encouraging the puzzle solver to think creatively.
    
    Your response should be in valid JSON format with the following structure:
    {
      "emojis": "unicode_emoji1 unicode_emoji2 ...",
      "hint": "Your hint text here",
      "color": "The SwiftUI color here",
      "solution": "The original word or phrase"
    }
    
    Example output for the prompt 'Starbucks':
    {
      "emojis": "⭐️ 💵",
      "hint": "Your daily fix",
      "color": "brown",
      "solution": "Starbucks"
    }
    
    Remember to use unicode representations for the emojis and ensure your output is in valid JSON format.
    
    Here is the word or phrase to base your emoji puzzle on:
    """

    var body: some View {

        VStack{
            Spacer()
            Text("Make an emoji puzzle!")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            if emojis == "" {
                ProgressView()
                    .controlSize(.large)
                    .frame(maxHeight: 280)
            }else {
                VStack(spacing:12){
                    Text(emojis)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.1)
                        .frame(maxWidth:.infinity)
                        .padding(.vertical, 72)
                    Text("Hint: \(hint)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(16)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .cornerRadius(30)
                }
                .frame(maxWidth:.infinity, maxHeight: 280)
                .transition(.scale)
            }
            

            Spacer()

            VStack(spacing:8){
                TextField("ex. Mountain Dew", text:$prompt)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black.opacity(0.24), lineWidth: 2)
                    )
                    .background(Color(.white))
                    .cornerRadius(10)

                Button{

                    emojis = ""
                    hint = ""

                    Task{
                        do{
                            let prompt = "\n\nHuman: \(instructions + prompt)\n\nAssistant:"
                            let requestBody = AnthropicMessageRequestBody(
                                maxTokens: 1024,
                                messages: [
                                    .init(content: [.text(prompt)], role: .user)
                                ],
                                model: "claude-3-5-sonnet-20240620"
                            )
                            let response = try await service.messageRequest(body: requestBody)
                            if let puzzle = getPuzzle(fromClaudeResponse: response) {
                                updateUI(withPuzzle: puzzle)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }label:{
                    Text("Generate Puzzle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color(string: color))
                .fontWeight(.bold)

            }
            .padding(.horizontal,24)
            Spacer()
        }
    }

    func getPuzzle(fromClaudeResponse response: AnthropicMessageResponseBody) -> Puzzle? {
        // We expected Claude to return a single text content in the response:
        guard case .text(let messageContent) = response.content.first else {
            print("Claude didn't return a text response")
            return nil
        }

        print("Puzzle content:\n\n\(messageContent)")
        guard let jsonData = messageContent.data(using: .utf8) else {
            print("Could not convert Claude's message to jsonData")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Puzzle.self, from: jsonData)
        } catch {
            print("Error decoding puzzle JSON: \(error)")
            return nil
        }
    }

    func updateUI(withPuzzle puzzle: Puzzle) {
        withAnimation(.snappy){
            emojis = puzzle.emojis
            hint = puzzle.hint
            color = puzzle.color
        }
    }
}

// Define the struct that matches the JSON structure
struct Puzzle: Codable {
    let emojis: String
    let hint: String
    let color: String
    let solution: String
}

extension Color {
    init?(string: String) {
        switch string.lowercased() {
        case "red":
            self = .red
        case "orange":
            self = .orange
        case "yellow":
            self = .yellow
        case "green":
            self = .green
        case "blue":
            self = .blue
        case "purple":
            self = .purple
        case "pink":
            self = .pink
        case "black":
            self = .black
        case "white":
            self = .white
        case "gray":
            self = .gray
        case "teal":
            self = .teal
        default:
            return nil
        }
    }
}

#Preview {
    ContentView()
}
