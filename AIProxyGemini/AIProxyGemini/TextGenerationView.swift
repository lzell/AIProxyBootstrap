//
//  TextGenerationView.swift
//  AIProxyGemini
//
//  Created by Todd Hamilton on 10/18/24.
//

import SwiftUI
import AIProxy

struct TextGenerationView: View {
    
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let requestBody = GeminiGenerateContentRequestBody(
                model: "gemini-1.5-flash",
                contents: [
                    .init(
                        parts: [.init(text: "Tell me a joke")]
                    )
                ]
            )
            let response = try await geminiService.generateContentRequest(body: requestBody)
            for part in response.candidates?.first?.content?.parts ?? [] {
                switch part {
                case .text(let text):
                    print("Gemini sent: \(text)")
                    result = text
                }
            }
            if let usage = response.usageMetadata {
                print(
                    """
                    Used:
                     \(usage.promptTokenCount ?? 0) prompt tokens
                     \(usage.cachedContentTokenCount ?? 0) cached tokens
                     \(usage.candidatesTokenCount ?? 0) candidate tokens
                     \(usage.totalTokenCount ?? 0) total tokens
                    """
                )
            }
            
            showingAlert = true
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received \(statusCode) status code with response body: \(responseBody)")
        } catch {
            print("Could not create Gemini generate content request: \(error.localizedDescription)")
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
        .navigationTitle("Chat Completion")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TextGenerationView()
}
