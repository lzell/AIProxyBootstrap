//
//  VisionView.swift
//  AIProxyAnthropic
//
//  Created by Todd Hamilton on 8/14/24.
//

import SwiftUI
import AIProxy

struct VisionView: View {
    
    @State private var prompt:String = ""
    @State private var result:String = ""
    @State private var showingAlert = false
    @State private var isLoading = false
    
    func generate() async throws {
        
        guard let image = UIImage(named: "climber") else {
            print("Could not find an image named 'marina' in your app assets")
            return
        }

        guard let jpegData = AIProxy.encodeImageAsJpeg(image: image, compressionQuality: 0.8) else {
            print("Could not convert image to jpeg")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await anthropicService.messageRequest(body: AnthropicMessageRequestBody(
                maxTokens: 1024,
                messages: [
                    AnthropicInputMessage(content: [
                        .text("Provide a very short description of this image"),
                        .image(mediaType: .jpeg, data: jpegData.base64EncodedString())
                    ], role: .user)
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
        VStack{
            VStack{
                Image("climber")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            .alert(isPresented: $showingAlert){
                Alert(
                    title: Text("Result"),
                    message: Text("\(result)"),
                    dismissButton: .default(Text("Close"))
                )
            }
            
            Spacer()
            
            VStack(spacing:12){
                Button{
                    Task {
                        try await generate()
                    }
                }label: {
                    if isLoading {
                        ProgressView()
                            .controlSize(.regular)
                            .frame(maxWidth:.infinity)
                    } else {
                        Text("Describe Image")
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
        .navigationTitle("Vision Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VisionView()
}
