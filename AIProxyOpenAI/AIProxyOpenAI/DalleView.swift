//
//  DalleView.swift
//  AIProxyOpenAI
//
//  Created by Todd Hamilton on 8/13/24.
//

import SwiftUI
import AIProxy

struct DalleView: View {
    
    @State private var prompt = ""
    @State private var imageUrl: String?
    @State private var isLoading = false
    
    func generate() async throws {
        isLoading = true  // Start loading
        defer { isLoading = false }
        do {
            let requestBody = OpenAICreateImageRequestBody(
                prompt: prompt,
                model: "dall-e-3"
            )
            let response = try await openAIService.createImageRequest(body: requestBody)
            imageUrl = response.data.first?.url?.absoluteString ?? ""
//            print(response.data.first?.url ?? "")
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack{
                
            VStack{
                if (imageUrl != nil) {
                    AsyncImage(url: URL(string: imageUrl!)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            Text("Failed to load image")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                        }
                    }
                } else{
                    ContentUnavailableView(
                        "Generate an image",
                        systemImage: "photo.fill",
                        description: Text("Write a prompt below")
                    )
                }
            }
            .frame(maxHeight: .infinity)
            
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
        .navigationTitle("Generate Image")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DalleView()
}
