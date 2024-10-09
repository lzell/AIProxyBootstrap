//
//  TextToSpeechView.swift
//  AIProxyOpenAI
//
//  Created by Todd Hamilton on 10/9/24.
//

import SwiftUI
import AIProxy
import AVKit

struct TextToSpeechView: View {
    
    @State private var prompt = ""
    @State private var result = ""
    @State private var isLoading = false
    @State var audioPlayer: AVAudioPlayer!
    
    // List of available voices
    let voices = ["nova", "aria", "bella", "emma"] // Replace with actual voice names from OpenAI
    @State private var selectedVoice = "nova" // Default selected voice
    
    func generate() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            let requestBody = OpenAITextToSpeechRequestBody(
                input: prompt,
                voice: OpenAITextToSpeechRequestBody.Voice(rawValue: selectedVoice) ?? .nova
            )

            let mpegData = try await openAIService.createTextToSpeechRequest(body: requestBody)

            // Do not use a local `let` or `var` for AVAudioPlayer.
            // You need the lifecycle of the player to live beyond the scope of this function.
            // Instead, use file scope or set the player as a member of a reference type with long life.
            // For example, at the top of this file you may define:
            //
            //   fileprivate var audioPlayer: AVAudioPlayer? = nil
            //
            // And then use the code below to play the TTS result:
            audioPlayer = try AVAudioPlayer(data: mpegData)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received \(statusCode) status code with response body: \(responseBody)")
        } catch {
            print("Could not create ElevenLabs TTS audio: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            VStack{
                ContentUnavailableView(
                    "Text-to-Speech",
                    systemImage: "doc.plaintext.fill",
                    description: Text("Write a prompt and select a voice")
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
                
                // Voice Picker
                Picker("Select Voice", selection: $selectedVoice) {
                    ForEach(voices, id: \.self) {
                        Text($0.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Button{
                    Task{ try await generate() }
                }label:{
                    if isLoading {
                        ProgressView()
                            .controlSize(.regular)
                            .frame(maxWidth:.infinity)
                    } else {
                        Text("Generate Speech")
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
        .navigationTitle("Text-to-Speech")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TextToSpeechView()
}
