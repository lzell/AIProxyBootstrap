//
//  StreamingChatView.swift
//  AIProxyOpenAI
//
//  Created by Todd Hamilton on 8/13/24.
//

import SwiftUI
import AIProxy

struct StreamingChatView: View {
    
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    
    func generate() async throws {
        
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.user(content: .text(prompt))]
        )
        isLoading = true
        defer { isLoading = false }
        do {
            let stream = try await openAIService.streamingChatCompletionRequest(body: requestBody)
            for try await chunk in stream {
                print(chunk.choices.first?.delta.content ?? "")
            }
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            VStack{
                ContentUnavailableView(
                    "Generate Text",
                    systemImage: "doc.plaintext.fill",
                    description: Text("Write a prompt below")
                )
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Result"),
                    message: Text("View the streaming response in the Xcode console."),
                    dismissButton: .default(Text("Close"))
                )
            }

            Spacer()
            
            VStack(spacing:12){
                TextField("Type a prompt", text:$prompt)
                    .submitLabel(.go)
                    .padding(12)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(color:.primary, radius: 1)
                    .onSubmit {
                        Task{ try await generate() }
                    }
                Button{
                    showingAlert = true
                    Task{ try await generate() }
                }label:{
                    if isLoading {
                        ProgressView()
                            .controlSize(.regular)
                            .frame(maxWidth:.infinity)
                    } else {
                        Text("Generate Text")
                            .bold()
                            .frame(maxWidth:.infinity)
                    }
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .disabled(isLoading ? true : false)
            }
        }
        .padding()
        .navigationTitle("Streaming Chat Completion")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    StreamingChatView()
}
