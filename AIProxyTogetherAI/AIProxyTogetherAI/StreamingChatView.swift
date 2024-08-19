//
//  StreamingChatView.swift
//  AIProxyTogetherAI
//
//  Created by Todd Hamilton on 8/18/24.
//

import SwiftUI
import AIProxy

struct StreamingChatView: View {
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let requestBody = TogetherAIChatCompletionRequestBody(
                messages: [TogetherAIMessage(content: prompt, role: .user)],
                model: "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo"
            )
            let stream = try await togetherAIService.streamingChatCompletionRequest(body: requestBody)
            for try await chunk in stream {
                print(chunk.choices.first?.delta.content ?? "")
            }
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print("Could not create TogetherAI streaming chat completion: \(error.localizedDescription)")
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
                    message: Text("View streaming response in the Xcode console."),
                    dismissButton: .default(Text("Close"))
                )
            }

            Spacer()
            
            VStack(spacing:12){
                TextField("Type a prompt", text:$prompt)
                    .submitLabel(.go)
                    .padding(12)
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
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
        .navigationTitle("Streaming Chat Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    StreamingChatView()
}
