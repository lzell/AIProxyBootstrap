//
//  CameraFrameManager.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import AVFoundation
import Foundation
import SwiftUI

@MainActor
@Observable
final class CameraFrameManager {

    /// The most recent camera frame of the back-facing built-in camera
    private(set) var cameraFrameImage: CGImage?
    private let cameraDataLoader = CameraDataLoader()

    init() {
        self.checkPermission() { [weak self] granted in
            if granted {
                self?.startCapturingCameraFrames()
            }
        }
    }

    private func startCapturingCameraFrames() {
        Task {
            let stream = await self.cameraDataLoader.imageStream()
            for await image in stream {
                self.cameraFrameImage = image
            }
        }
    }

    private func checkPermission(checkComplete: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            checkComplete(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                checkComplete(granted)
            }
        default:
            checkComplete(false)
        }
    }
}
