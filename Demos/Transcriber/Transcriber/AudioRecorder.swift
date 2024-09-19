//
//  Manager.swift
//  OpenAIExperiment
//
//  Created by Lou Zell
//

import AVFoundation
import Foundation

@AudioActor
final class AudioRecorder {
    private var microphoneSampleVendor: MicrophoneSampleVendor?
    private var audioFileWriter: AudioFileWriter?

    nonisolated init() {}
    
    /// Start recording an audio file
    /// - Returns: true if the audio recorder was able to start recording, false otherwise
    func start() -> Bool {
        do {
            self.microphoneSampleVendor = try MicrophoneSampleVendor()
        } catch {
            AppLogger.error("Could not create a MicrophoneSampleVendor: \(error)")
            return false
        }

        do {
            self.audioFileWriter = try AudioFileWriter(fileURL: FileUtils.getFileURL())
        } catch {
            AppLogger.error("Could not create an audio file writer: \(error)")
            return false
        }

        self.microphoneSampleVendor?.start(onSample: { [weak self] sampleBuffer in
            self?.audioFileWriter?.append(sample: sampleBuffer)
        })
        return true
    }

    /// Returns the recording created between calls to `startRecording` and `stopRecording`
    func stopRecording(duration: String) async -> AudioRecording? {
        guard let fileWriter = self.audioFileWriter,
              let sampleVendor = self.microphoneSampleVendor else
        {
            AppLogger.warning("Expected audio dependencies to be set")
            return nil
        }
        sampleVendor.stop()
        let url = await fileWriter.finishWriting()
        return AudioRecording(localUrl: url, duration: duration)
    }
}
