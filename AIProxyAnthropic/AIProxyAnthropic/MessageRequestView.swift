//
//  MessageRequestView.swift
//  AIProxyAnthropic
//
//  Created by Todd Hamilton on 8/14/24.
//

import SwiftUI
import AIProxy

struct MessageRequestView: View {
    
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await anthropicService.messageRequest(body: AnthropicMessageRequestBody(
                maxTokens: 1024,
                messages: [
                    AnthropicInputMessage(content: [.text(prompt)], role: .user)
                ],
                model: "claude-3-5-sonnet-20240620"
            ))
            for content in response.content {
                switch content {
                case .text(let message):
                    print("Claude sent a message: \(message)")
                    result = message
                    showingAlert = true
                case .toolUse(id: _, name: let toolName, input: let toolInput):
                    print("Claude used a tool \(toolName) with input: \(toolInput)")
                }
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
                    "Generate Message",
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
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(color:.primary, radius: 1)
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
                        Text("Generate Message")
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
        .navigationTitle("Message Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MessageRequestView()
}
