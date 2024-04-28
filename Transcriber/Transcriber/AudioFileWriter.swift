//
//  AudioFileWriter.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import AVFoundation

/// One of the following errors will be thrown at initialization if the microphone vendor can't vend samples.
enum AudioFileWriterError: Error {
    case couldNotWriteToDestinationURL
    case couldNotCreateAudioInput
}


/// Writes an m4a file out of audio sample buffers.
/// Samples passed to the `append` method will be written to the m4a file between calls to `init()` and `finishWriting()`.
/// Create one instance of AudioFileWriter for each audio file that you'd like to write.
@AudioActor
final class AudioFileWriter {
    /// The location to write the audio file to
    let fileURL: URL

    private let assetWriter: AVAssetWriter
    private let microphoneWriter: AVAssetWriterInput
    private let audioSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVSampleRateKey: 48_000,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    private var isWriting = false
    
    /// Throws one of `AudioFileWriterError` if we can't initialize the AVFoundation dependencies
    /// - Parameter fileURL: The location to write the audio file to
    init(fileURL: URL) throws {
        self.fileURL = fileURL
        do {
            self.assetWriter = try AVAssetWriter(outputURL: fileURL, fileType: .m4a)
        } catch {
            throw AudioFileWriterError.couldNotWriteToDestinationURL
        }

        self.microphoneWriter = AVAssetWriterInput(mediaType: .audio, outputSettings: self.audioSettings)
        self.microphoneWriter.expectsMediaDataInRealTime = true

        if self.assetWriter.canAdd(self.microphoneWriter) {
            self.assetWriter.add(self.microphoneWriter)
        } else {
            throw AudioFileWriterError.couldNotCreateAudioInput
        }
    }
    
    /// Append a sample buffer to the audio file
    /// - Parameter sample: A core media sample buffer. See the `MicrophoneSampleVendor` file for an example of how to source these.
    func append(sample: CMSampleBuffer) {
        if !self.isWriting {
            self.assetWriter.startWriting()
            self.assetWriter.startSession(atSourceTime: sample.presentationTimeStamp)
            self.isWriting = true
        }
        if self.microphoneWriter.isReadyForMoreMediaData {
            self.microphoneWriter.append(sample)
        } else {
            AppLogger.warning("The AudioFileWriter is not ready for more audio data")
        }
    }
    
    /// Finishes writing the file to disk
    /// - Returns: URL location of the m4a file on disk
    func finishWriting() async -> URL {
        self.microphoneWriter.markAsFinished()
        await self.assetWriter.finishWriting()
        self.isWriting = false
        return self.fileURL
    }
}
