//
//  ContentView.swift
//  PuLIDDemo
//
//  Created by Todd Hamilton on 9/26/24.
//

import SwiftUI
import AIProxy
import PhotosUI

struct ContentView: View {

    @State var isAnimating = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: UIImage? = UIImage(named: "pulid")
    @State var prompt = ""
    @State private var isLoading = false
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    @FocusState var isFocused : Bool
    
    var body: some View {
        ZStack {
            
            if #available(iOS 18.0, *) {
                MeshGradient(width: 2, height: 2, points: [
                    [0, 0], [1, 0], [0, 1], [1, 1]
                ], colors: [.blue, .teal, .cyan, .blue])
                .ignoresSafeArea()
            } else {
                // Fallback on earlier versions
                Color.purple
            }
            
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                    
            VStack{
                
                ZStack(alignment: .bottom){

                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height:400)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.white.opacity(0.75), .white.opacity(0.25), .white.opacity(0.25), .white.opacity(0.15), .white.opacity(0.15)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                                    .blendMode(.overlay)
                            )
                            .cornerRadius(16)
                            .modifier(RippleEffect(at: origin, trigger: counter))
                            .shadow(color:.black.opacity(0.14),radius: 24)
                            .shadow(radius: 25)
                        

                        PhotosPicker(selection: $selectedPhoto, matching: .images){
                            Image(systemName: "photo.circle.fill")
                        }
                        .foregroundStyle(.regularMaterial)
                        .buttonBorderShape(.circle)
                        .padding()
                        .font(.largeTitle)
                        .textCase(.uppercase)

                        if isLoading{
                            ProgressView(){
                                Text("Generating")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12, weight:.semibold, design: .monospaced))
                            }
                            .tint(.white)
                            .frame(maxWidth: .infinity, maxHeight: 400)
                            .background(.black.opacity(0.5))
                            .cornerRadius(16)
                        }
                    }
                }
                .padding()
                .task(id: selectedPhoto) {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
                
                VStack(spacing:12){
                    
                    Text("Type a prompt to generate a new image.")
                        .font(.caption)
                        .fontWeight(.medium)
                        .textCase(.uppercase)
                        .foregroundStyle(.white)
                        .fontDesign(.monospaced)
                    
                    ZStack{
                        TextField("Prompt", text: $prompt)
                            .focused($isFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                isFocused = false
                                Task{ try await generateImage() }
                            }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 12)
                    .fontDesign(.monospaced)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .font(.system(size: 14))
                    .shadow(radius: 24)
                    
                    HStack{
                        Button("Generate"){
                            isFocused = false
                            Task{ try await generateImage() }
                        }
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .textCase(.uppercase)
                        .controlSize(.large)
                        .padding(8)
                        .buttonStyle(.borderedProminent)
                        .tint(.teal)
                        .disabled(isLoading ? true : false)
                    }
                    
                }
                .padding(16)
                
                Spacer()
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func generateImage() async throws {
        
        withAnimation(.default.delay(0.5)){ isLoading = true }
        
        defer {
            withAnimation(){ isLoading = false }
        }
        
        guard let imageURL = AIProxy.encodeImageAsURL(image: image!, compressionQuality: 0.8) else {
            print("Could not convert image to a local data URI")
            return
        }

        do {
            let input = ReplicateFluxPulidInputSchema(
                mainFaceImage: imageURL,
                prompt: prompt,
                numOutputs: 1,
                startStep: 4
            )
            let output = try await replicateService.createFluxPulidImage(
                input: input
            )
            print("Done creating Flux-PuLID image: ", output)
            
            if let url = output.first?.absoluteString {
                image = await loadImage(from: url)
            }
            
            counter += 1
            
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print("Could not create Flux-Pulid images: \(error.localizedDescription)")
        }
       
    }
    
    // Function to load an image from a URL
    private func loadImage(from url: String) async -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image from URL: \(error.localizedDescription)")
            return nil
        }
    }
    
}

#Preview {
    ContentView()
}
