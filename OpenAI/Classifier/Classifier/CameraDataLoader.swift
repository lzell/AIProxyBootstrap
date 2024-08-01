//
//  CameraFrameHandler.swift
//  AIProxyBootstrap
//
//  Created by Todd Hamilton
//

import AVFoundation
import CoreImage

/// Vends camera frames from the built-in back camera.
final actor CameraDataLoader {
    private let sampleBufferDelegate = CameraFrameSampleBufferDelegate()
    private let captureSession = AVCaptureSession()

    /// Streams images of the camera frame.
    /// Use the returned stream in a `for await` loop.
    func imageStream() -> AsyncStream<CGImage> {
        self.setupCaptureSession()
        self.captureSession.startRunning()
        return AsyncStream { [weak self] continuation in
            self?.sampleBufferDelegate.didReceiveImage = { image in
                continuation.yield(image)
            }
        }
    }

    private func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera,for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)

        videoOutput.setSampleBufferDelegate(
            sampleBufferDelegate,
            queue: AppConstants.videoSampleQueue
        )
        captureSession.addOutput(videoOutput)

        videoOutput.connection(with: .video)?.videoRotationAngle = 90
    }
}


private final class CameraFrameSampleBufferDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let coreImageContext = CIContext()
    var didReceiveImage: ((CGImage) -> Void)?

    /// Delegate implementation for AVCaptureVideoDataOutputSampleBufferDelegate conformance
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        dispatchPrecondition(condition: .onQueue(AppConstants.videoSampleQueue))
        guard let cgImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            AppLogger.info("Could not convert a sample buffer from the camera into a CGImage")
            return
        }

        self.didReceiveImage?(cgImage)
    }

    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            AppLogger.info("Could not get an image buffer from CMSampleBuffer")
            return nil
        }

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = self.coreImageContext.createCGImage(ciImage, from: ciImage.extent) else {
            AppLogger.info("Could not create a CGImage using a core image context")
            return nil
        }

        return cgImage
    }
}
