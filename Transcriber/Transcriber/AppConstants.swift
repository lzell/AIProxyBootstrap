//
//  AppConstants.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftData
import SwiftOpenAI

/*
 Thanks to James Rochabrun for his excellent work on the SwiftOpenAI library.
 His license for SwiftOpenAI is reproduced here:

 MIT License

 Copyright (c) 2023 James Rochabrun

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

/// Use this actor for audio work
@globalActor actor AudioActor {
    static let shared = AudioActor()
}

enum AppConstants {

    static let swiftDataModels: [any PersistentModel.Type] = [AudioRecording.self, TranscribedAudioRecording.self]
    static let swiftDataContainer = try! ModelContainer(for: AudioRecording.self, TranscribedAudioRecording.self)

    static let audioSampleQueue = DispatchQueue(label: "com.AIProxyBootstrap.audioSampleQueue")

#warning("You must change the placeholders below for building and running")
#if DEBUG && targetEnvironment(simulator)
    static let openAI: some OpenAIService = OpenAIServiceFactory.service(
        aiproxyPartialKey: "hardcode_partial_key_here",
        aiproxyDeviceCheckBypass: "hardcode_device_check_bypass_here")
#else
    static let openAI: some OpenAIService = OpenAIServiceFactory.service(
        aiproxyPartialKey: "hardcode_partial_key_here")
#endif
}
