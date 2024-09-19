//
//  AppConstants.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import AIProxy

enum AppConstants {
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
