//
//  TranscribedAudioRecording.swift
//  Transcriber
//
//  Created by Lou Zell
//

import AVFoundation
import Foundation
import SwiftData

/// Encapsulates a transcribed audio recording
@Model
final class TranscribedAudioRecording {
    @Relationship(deleteRule: .cascade) var audioRecording: AudioRecording
    let transcript: String
    let createdAt: Date
    @Transient var player: AVAudioPlayer?

    init(audioRecording: AudioRecording, transcript: String, createdAt: Date) {
        self.audioRecording = audioRecording
        self.transcript = transcript
        self.createdAt = createdAt
    }

    func play() {
        guard let resolvedURL = self.audioRecording.resolvedURL else {
            AppLogger.error("The audio recording model does not have an associated audio file")
            return
        }
        AppLogger.info("Playing file at \(resolvedURL), which exists? \(FileManager.default.fileExists(atPath: resolvedURL.path))")

        Task.detached {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                self.player = try AVAudioPlayer(contentsOf: resolvedURL)
                self.player?.play()
            } catch {
                AppLogger.error("Could not play audio file. Error: \(error.localizedDescription)")
            }
        }
     }
}
