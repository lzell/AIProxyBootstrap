//
//  AppConstants.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftData
import AIProxy

enum AppConstants {
    
    static let videoSampleQueue = DispatchQueue(label: "com.AIProxyBootstrap.videoSampleQueue")
    
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
