//
//  StickerDataLoader.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import Vision
import UIKit
import SwiftOpenAI

final actor StickerDataLoader {
    /// Creates a sticker from a given `prompt` using OpenAI's APIs
    /// On simulator, the sticker has an opaque background because the Vision framework is not available.
    /// On device, the sticker has a transparent background
    ///
    /// - Parameter prompt: The user-entered prompt
    /// - Returns: A sticker as a UIImage if we were able to get one from OpenAI, or nil otherwise
    func create(fromPrompt prompt: String) async throws -> UIImage? {
        
        let adjustedPrompt = "cute design of a " + prompt + " kawaii sticker. nothing in the bg. white bg."
        let createParameters = ImageCreateParameters(prompt: adjustedPrompt, model: .dalle3(.largeSquare))
        let response = try await AppConstants.openAI.createImages(parameters: createParameters)
        
        guard let url = response.data.first?.url, let data = try? Data(contentsOf: url) else {
            AppLogger.error("OpenAI returned a sticker imageURL that we could not fetch")
            return nil
        }

        guard let img = UIImage(data: data) else {
            AppLogger.error("Could not create a UIImage from the imageURL provided by OpenAI")
            return nil
        }

        return img.extractForegroundWithVision() ?? img
    }
}


private extension UIImage {

    convenience init?(pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        self.init(cgImage: cgImage)
    }

    func extractForegroundWithVision() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        do {
            try handler.perform([request])
            guard let result = request.results?.first else { return nil }

            let foregroundPixelBuffer = try result.generateMaskedImage(
                ofInstances: result.allInstances,
                from: handler,
                croppedToInstancesExtent: false
            )

            if let foregroundImage = UIImage(pixelBuffer: foregroundPixelBuffer) {
                return foregroundImage
            }
        } catch {
            AppLogger.info("Could not use Vision to cut the sticker out. Perhaps you are running on simulator?")
        }
        return nil
    }
}
