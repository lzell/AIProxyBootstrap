//
//  ImageGenView.swift
//  AIProxyFal
//
//  Created by Todd Hamilton on 6/13/24.
//

import SwiftUI
import AIProxy

struct TextToImageView: View {
    
    @State private var prompt: String = ""
    @State private var imageUrl: String?
    @State private var isLoading: Bool = false
    
    private func generate() async throws {
        
        let input = FalFastSDXLInputSchema(
            prompt: prompt,
            enableSafetyChecker: false
        )
        isLoading = true  // Start loading
        defer { isLoading = false }
        do {
            let output = try await falService.createFastSDXLImage(input: input)
            print("""
                  The first output image is at \(output.images?.first?.url?.absoluteString ?? "")
                  It took \(output.timings?.inference ?? Double.nan) seconds to generate.
                  """)
            imageUrl = output.images?.first?.url?.absoluteString
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print("Could not create Fal SDXL image: \(error.localizedDescription)")
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
                        Text("Generate Image")
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
    TextToImageView()
}
