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
        do {
            let requestBody = OpenAICreateTranscriptionRequestBody(
                file: try Data(contentsOf: recording.localUrl),
                model: "whisper-1"
            )
            let response = try await AppConstants.openAIService.createTranscriptionRequest(body: requestBody)
            return response.text
        } catch {
            AppLogger.error("Could not get transcript from OpenAI: \(error.localizedDescription)")
            return "Transcription Error"
        }
    }
}
