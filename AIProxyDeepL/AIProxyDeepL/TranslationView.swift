//
//  TranslationView.swift
//  AIProxyDeepL
//
//  Created by Todd Hamilton on 8/14/24.
//

import SwiftUI
import AIProxy

struct TranslationView: View {
    
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let body = DeepLTranslateRequestBody(targetLang: "ES", text: [prompt])
            let response = try await deepLService.translateRequest(body: body)
            // Do something with `response.translations`
            result = response.translations.first?.text ?? ""
            showingAlert = true
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print("Could not create translation: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            VStack{
                ContentUnavailableView(
                    "Translate to Spanish",
                    systemImage: "captions.bubble.fill",
                    description: Text("Write text you want to translate below")
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
                TextField("Type your text here", text:$prompt)
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
                        Text("Translate")
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
        .navigationTitle("Translate Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TranslationView()
}
