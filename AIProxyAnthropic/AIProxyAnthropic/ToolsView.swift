//
//  ToolsView.swift
//  AIProxyAnthropic
//
//  Created by Todd Hamilton on 8/14/24.
//

import SwiftUI
import AIProxy

struct ToolsView: View {
    
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            VStack{
                ContentUnavailableView(
                    "Stock Symbol Lookup",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Type the name of the company you want the symbol for.")
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
                TextField("Type a company", text:$prompt)
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
                        Text("Look Up")
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
        .navigationTitle("Tools Example")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let requestBody = AnthropicMessageRequestBody(
                maxTokens: 1024,
                messages: [
                    .init(
                        content: [.text(prompt)],
                        role: .user
                    )
                ],
                model: "claude-3-5-sonnet-20240620",
                tools: [
                    .init(
                        description: "Call this function when the user wants a stock symbol",
                        inputSchema: [
                            "type": "object",
                            "properties": [
                                "ticker": [
                                    "type": "string",
                                    "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
                                ]
                            ],
                            "required": ["ticker"]
                        ],
                        name: "get_stock_symbol"
                    )
                ]
            )
            let response = try await anthropicService.messageRequest(body: requestBody)
            
            for content in response.content {
                switch content {
                case .text(let message):
                    print("Claude sent a message: \(message)")
                case .toolUse(id: _, name: let toolName, input: let toolInput):
                    print("Claude used a tool \(toolName) with input: \(toolInput)")
                    result = toolInput.description
                    showingAlert = true
                }
            }
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ToolsView()
}
