//
//  AppConstants.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftData
import AIProxy

/// Use this actor for audio work
@globalActor actor AudioActor {
    static let shared = AudioActor()
}

enum AppConstants {

    static let swiftDataModels: [any PersistentModel.Type] = [AudioRecording.self, TranscribedAudioRecording.self]
    static let swiftDataContainer = try! ModelContainer(for: AudioRecording.self, TranscribedAudioRecording.self)

    static let audioSampleQueue = DispatchQueue(label: "com.AIProxyBootstrap.audioSampleQueue")

    #warning(
        """
        You must follow the AIProxy integration guide to build and run on device.
        Please see https://www.aiproxy.pro/docs/integration-guide.html")
        """
    )

    static let openAIService = AIProxy.openAIService(
        partialKey: "hardcode_partial_key_here",
        serviceURL: "hardcode_service_url_here"
    )
}
