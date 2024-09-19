//
//  TranscriberDataLoader.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import AIProxy

/// Interfaces with OpenAI to convert a recording into a transcript
final actor TranscriberDataLoader {
    
    /// Run the OpenAI transcriber on an audio recording
    /// - Parameter recording: the audio recording to transcribe
    /// - Returns: a transcript of the recording created by OpenAI's Whisper model
    func run(onRecording recording: AudioRecording) async -> String {
        let data = try! Data(contentsOf: recording.url)

        do {
//            let transcript = try await AppConstants.openAI.createTranscription(parameters: .init(fileName: "transcribe.m4a", file: data)).text
            
            let url = Bundle.main.url(forResource: "transcribe", withExtension: "m4a")!
            let requestBody = OpenAICreateTranscriptionRequestBody(
                file: try Data(contentsOf: url),
                model: "whisper-1",
                responseFormat: "verbose_json",
                timestampGranularities: [.word, .segment]
            )
            let response = try await AppConstants.openAIService.createTranscriptionRequest(body: requestBody)
            return response.text
        } catch {
            AppLogger.error("Could not get transcript from OpenAI")
            return "Transcription Error"
        }
    }
}
