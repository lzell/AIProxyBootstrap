//
//  ImageToVideoView.swift
//  AIProxyFal
//
//  Created by Todd Hamilton on 10/4/24.
//

import SwiftUI
import AIProxy

struct ImageToVideoView: View {
    
    @State private var prompt: String = "A delorean driving down the road"
    @State private var imageUrl: String = "https://coolmaterial.com/wp-content/uploads/2016/03/delorean5.jpg"
    @State private var isLoading: Bool = false
    @State private var videoUrl: String?
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing:48){
                
            AsyncImage(url: URL(string: imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                } else if phase.error != nil {
                    Text("No Image Found")
                        .foregroundColor(.red)
                        .frame(maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 2)
                        )
                } else {
                    ProgressView()
                }
            }
            
            VStack(spacing:12){
                TextField("Image URL", text:$imageUrl)
                    .submitLabel(.go)
                    .padding(12)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(color:.primary, radius: 1)
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
                        Text("Generate Video")
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
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Result"),
                message: Text(videoUrl ?? "No video URL found"),
                primaryButton: .default(Text("Open Video")) {
                    openURL(URL(string:videoUrl!)!)
                },
                secondaryButton: .cancel(Text("Dismiss"))
            )
        }
    }
    
    private func generate() async throws {

        isLoading = true  // Start loading
        defer { isLoading = false }
        
        let input = FalRunwayGen3AlphaInputSchema(
            imageUrl: imageUrl,
            prompt: prompt
        )
        do {
            let output = try await falService.createRunwayGen3AlphaVideo(input: input)
            print(output.video?.url?.absoluteString ?? "No video URL")
            videoUrl = output.video?.url?.absoluteString ?? ""
            showingAlert = true
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print("Could not create Fal Runway Gen3 Alpha video: \(error.localizedDescription)")
        }
    }
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

#Preview {
    ImageToVideoView()
}
