//
//  MicrophoneSampleVendor.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import CoreMedia
import AVFoundation

/// One of the following errors will be thrown at initialization if the microphone vendor can't vend samples.
enum MicrophoneSampleVendorError: Error {
    case micNotFound
    case micNotUsableAsCaptureDevice
    case captureSessionRejectedMic
    case captureSessionRejectedOutput
}


/// Vends samples of the microphone audio
///
/// ## Requirements
///
/// - Assumes an `NSMicrophoneUsageDescription` description has been added to Target > Info
/// - Assumes that microphone permissions have already been granted
///
/// ## Usage
///
/// ```
///     self.microphoneVendor = try MicrophoneSampleVendor()
///     self.microphoneVendor.start { sample in
///        // Do something with `sample`
///        // Note: this callback is invoked on a background thread
///     }
/// ```
///
@AudioActor
final class MicrophoneSampleVendor {

    private let captureSession = AVCaptureSession()
    private let audioOutput = AVCaptureAudioDataOutput()
    private let sampleBufferDelegate = SampleBufferDelegate()

    init() throws {
        let mic = try findMic()
        let micInput = try mic.asInput()
        try self.captureSession.addMicInput(micInput)
        try self.captureSession.addAudioOutput(self.audioOutput)
        self.audioOutput.setSampleBufferDelegate(self.sampleBufferDelegate,
                                                 queue: AppConstants.audioSampleQueue)
    }

    func start(onSample: @escaping (CMSampleBuffer) -> Void) {
        self.sampleBufferDelegate.sampleCallback = onSample
        self.captureSession.startRunning()
    }

    func stop() {
        self.captureSession.stopRunning()
    }
}

private class SampleBufferDelegate: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    var sampleCallback: ((CMSampleBuffer) -> Void)?

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        dispatchPrecondition(condition: .onQueue(AppConstants.audioSampleQueue))
        self.sampleCallback?(sampleBuffer)
    }
}

private func findMic() throws -> AVCaptureDevice {
    let microphones = AVCaptureDevice.DiscoverySession(deviceTypes: [.microphone], mediaType: .audio, position: .unspecified).devices
    if let mic = microphones.first {
        return mic
    }
    throw MicrophoneSampleVendorError.micNotFound
}

private extension AVCaptureDevice {
    func asInput() throws -> AVCaptureDeviceInput {
        do {
            return try AVCaptureDeviceInput(device: self)
        } catch {
            throw MicrophoneSampleVendorError.micNotUsableAsCaptureDevice
        }
    }
}

private extension AVCaptureSession {
    func addMicInput(_ micInput: AVCaptureDeviceInput) throws {
        if self.canAddInput(micInput) {
            self.addInput(micInput)
        } else {
            throw MicrophoneSampleVendorError.captureSessionRejectedMic
        }
    }

    func addAudioOutput(_ audioOutput: AVCaptureAudioDataOutput) throws {
        if self.canAddOutput(audioOutput) {
            self.addOutput(audioOutput)
        } else {
            throw MicrophoneSampleVendorError.captureSessionRejectedMic
        }
    }
}
