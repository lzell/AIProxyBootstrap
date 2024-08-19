//
//  ChatView.swift
//  AIProxyTogetherAI
//
//  Created by Todd Hamilton on 8/18/24.
//

import SwiftUI
import AIProxy

struct ChatView: View {
    
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
            let response = try await togetherAIService.chatCompletionRequest(body: requestBody)
            print(response.choices.first?.message.content ?? "")
            result = response.choices.first?.message.content ?? ""
            showingAlert = true
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print("Could not create TogetherAI chat completion: \(error.localizedDescription)")
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
                    message: Text(result),
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
        .navigationTitle("Chat Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView()
}
