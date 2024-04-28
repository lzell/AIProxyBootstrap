//
//  TranscriberDataLoader.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation


/// Interfaces with OpenAI to convert a recording into a transcript
final actor TranscriberDataLoader {
    
    /// Run the OpenAI transcriber on an audio recording
    /// - Parameter recording: the audio recording to transcribe
    /// - Returns: a transcript of the recording created by OpenAI's Whisper model
    func run(onRecording recording: AudioRecording) async -> String {
        let data = try! Data(contentsOf: recording.url)

        do {
            let transcript = try await AppConstants.openAI.createTranscription(parameters: .init(fileName: "transcribe.m4a", file: data)).text
            return transcript
        } catch {
            AppLogger.error("Could not get transcript from OpenAI")
            return "Transcription Error"
        }
    }
}
