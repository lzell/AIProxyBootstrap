//
//  ImageGenView.swift
//  AIProxyStabilityAI
//
//  Created by Todd Hamilton on 8/13/24.
//

import SwiftUI
import AIProxy

struct ImageGenView: View {
    
    @State private var prompt = ""
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    
    func generate() async throws {
        isLoading = true  // Start loading
        defer { isLoading = false }
        do {
            let body = StabilityAIUltraRequestBody(prompt: prompt)
            
            // This demo is of text-to-image, which only requires a prompt
            // To use image-to-image the following parameters are required:
            // prompt - text to generate the image from
            // image - the image to use as the starting point for the generation
            // strength - controls how much influence the image parameter has on the output image
            // mode - must be set to image-to-image
            // Learn more: https://platform.stability.ai/docs/api-reference#tag/Generate
            
            let response = try await service.ultraRequest(body: body)
            image = UIImage(data: response.imageData)
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack{
                
            VStack{
                if (image != nil) {
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: UIScreen.main.bounds.width)
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
    ImageGenView()
}
