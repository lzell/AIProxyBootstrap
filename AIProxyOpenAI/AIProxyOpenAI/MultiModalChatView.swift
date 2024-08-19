//
//  MultiModalChatView.swift
//  AIProxyOpenAI
//
//  Created by Todd Hamilton on 6/14/24.
//

import SwiftUI
import AIProxy
import UIKit

struct MultiModalChatView: View {
    
    @State private var prompt:String = ""
    @State private var result:String = ""
    @State private var showingAlert = false
    @State private var isLoading = false
    
    var body: some View {
        VStack{
            VStack{
                Image("surfer")
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
        .navigationTitle("Describe Image")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        
        let image = UIImage(named: "surfer")
        let localURL = createOpenAILocalURL(forImage: image!)
        
        do {
            let response = try await openAIService.chatCompletionRequest(body: .init(
                model: "gpt-4o",
                messages: [
                    .init(
                        role: "system",
                        content: .text("Tell me what you see")
                    ),
                    .init(
                        role: "user",
                        content: .parts(
                            [
                                .text("What do you see?"),
                                .imageURL(localURL!)
                            ]
                        )
                    )
                ]
            ))
            result = (response.choices.first?.message.content)!
            showingAlert = true
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(String(describing: responseBody))")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createOpenAILocalURL(forImage image: UIImage) -> URL? {
        // Attempt to get JPEG data from the UIImage
        guard let jpegData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        // Encode the JPEG data to a base64 string
        let base64String = jpegData.base64EncodedString()
        
        // Create the data URL string
        let urlString = "data:image/jpeg;base64,\(base64String)"
        
        // Return the URL constructed from the data URL string
        return URL(string: urlString)
    }
 
}

#Preview {
    MultiModalChatView()
}

private extension CGImage {
    var jpegData: Data? {
        let uiImage = UIImage(cgImage: self)
        return uiImage.jpegData(compressionQuality: 1.0)
    }
}




