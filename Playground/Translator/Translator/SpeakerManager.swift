//
//  SpeakerManager.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import AVFoundation
import Foundation
import SwiftOpenAI
import SwiftUI

/// All audio work is performed in this serial queue.
/// If a client calls `speak` multiple times, the audio is spoken in serial.
private let speakerPlaybackQueue = DispatchQueue(label: "com.AIProxyBootstrap.Speaker.playback")

/// This queue is responsible for placing work in the `speakerPlaybackQueue`
private let feederQueue = DispatchQueue(label: "com.AIProxyBootstrap.Speaker.feeder")

/// A speaker. See the OpenAI options for the voices that the speaker can take.
///
/// ## Usage
/// The most likely use case is to use this Speaker in a SwiftUI app.
/// Create an instance of Speaker as a `let` constant in your view, e.g. `let speaker = Speaker()`.
/// The SwiftUI view can observe `speaker.isSpeaking` to determine which controls to display.
/// The main entry point for text-to-speech is `speaker.speak(text: "hello world")`
@Observable
final class SpeakerManager {
    /// An observable property that indicates if the speaker is actively speaking.
    private(set) var isSpeaking: Bool = false
    private let isReadyForMoreAudioWork = DispatchSemaphore(value: 1)
    private var speechesInProgress = [Speech]() {
        didSet {
            DispatchQueue.main.async {
                self.isSpeaking = self.speechesInProgress.count != 0
            }
        }
    }

    /// This is the Text-to-Speech entry point.
    ///
    /// - Parameter text: The text to speak
    func speak(text: String) {
        feederQueue.async { [weak self] in
            self?.isReadyForMoreAudioWork.wait()
            speakerPlaybackQueue.async { [weak self] in
                let speech = Speech(text: text)
                self?.speechesInProgress.append(speech)
                speech.play() { [weak self] in
                    self?.isReadyForMoreAudioWork.signal()
                    self?.speechesInProgress.removeAll { $0 == speech }
                }
            }
        }
    }
}


private final class Speech: NSObject, AVAudioPlayerDelegate {
    let text: String
    private var didFinishPlaying: (() -> Void)?
    private var avPlayer: AVAudioPlayer?

    init(text: String) {
        self.text = text
    }

    deinit {
        AppLogger.debug("Speech is being freed, with text \(self.text)")
    }

    func play(completion: @escaping () -> Void) {
        createAudioData(from: text) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let res):
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    this.avPlayer = try AVAudioPlayer(data: res.output, fileTypeHint: AVFileType.mp3.rawValue)
                    this.avPlayer?.delegate = self
                    this.avPlayer?.play()
                    this.didFinishPlaying = completion
                } catch {
                    AppLogger.error("Could not create an audio player to speak openai results. Error: \(error.localizedDescription)")
                    completion()
                }
            case .failure(let err):
                AppLogger.error("Could not create audio data using OpenAI. Error: \(err)")
                completion()
            }
        }
    }

    /// Delegate implementation of AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        assert(player == self.avPlayer, "Unexpected player in the AVAudioPlayerDelegate implementation")
        player.delegate = nil
        self.avPlayer?.delegate = nil
        self.avPlayer = nil
        self.didFinishPlaying?()
        self.didFinishPlaying = nil
    }
}

private func createAudioData(from text: String, completion: @escaping (Result<AudioSpeechObject, Error>) -> Void) {
    Task {
        do {
            let res = try await AppConstants.openAI.createSpeech(parameters: .init(model: .tts1, input: text, voice: .shimmer))
            completion(.success(res))
        } catch {
            completion(.failure(error))
        }
    }
}
