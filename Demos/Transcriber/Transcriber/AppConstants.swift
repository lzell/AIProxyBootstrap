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
        Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
        Please see https://www.aiproxy.pro/docs/integration-guide.html")
        """
    )

    /* Uncomment for BYOK use cases */
    static let openAIService = AIProxy.openAIDirectService(
        unprotectedAPIKey: "your-openai-key"
    )

    /* Uncomment for all other production use cases */
    // let openAIService = AIProxy.openAIService(
    //     partialKey: "partial-key-from-your-developer-dashboard",
    //     serviceURL: "service-url-from-your-developer-dashboard"
    // )
}
