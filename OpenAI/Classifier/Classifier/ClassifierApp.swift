//
//  ClassifierApp.swift
//  Classifier
//
//  Created by Lou Zell
//

import SwiftUI

@main
@MainActor
struct ClassifierApp: App {

    @State private var cameraFrameManager = CameraFrameManager()
    @State private var classifierManager = ClassifierManager()

    var body: some Scene {
        WindowGroup {
            ClassifierView(cameraFrameManager: cameraFrameManager,
                           classifierManager: classifierManager)
        }
    }
}
