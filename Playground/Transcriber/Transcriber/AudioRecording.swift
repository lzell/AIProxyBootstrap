//
//  AudioRecording.swift
//  Transcriber
//
//  Created by Lou Zell
//

import Foundation
import SwiftData

/// Encapsulates a recording. The `url` is the location on disk of the raw audio file (an m4a).
@Model
final class AudioRecording {
    @Attribute(.unique) let url: URL
    let duration: String

    init(url: URL, duration: String) {
        self.url = url
        self.duration = duration
    }

    var resolvedURL: URL? {
        // There is a little nuance here. Every time you build and run the app the apple sandbox changes.
        // We first try to find the associated file at the spot that we stored it, but if it's not there then
        // we construct a new URL based on the current apple sandbox
        if (FileManager.default.fileExists(atPath: self.url.path)) {
            return self.url
        } else {
            let resolvedURL = FileUtils.getDocumentsURL().appending(component: self.url.lastPathComponent)
            if FileManager.default.fileExists(atPath: resolvedURL.path) {
                return resolvedURL
            }
        }
        return nil
    }
}
