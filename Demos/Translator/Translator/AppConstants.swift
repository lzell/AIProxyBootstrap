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
