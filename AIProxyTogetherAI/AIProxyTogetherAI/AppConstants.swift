//
//  AppConstants.swift
//  AIProxyTogetherAI
//
//  Created by Todd Hamilton on 8/18/24.
//

import AIProxy

#error(
    """
    Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

/* Uncomment for BYOK use cases */
let togetherAIService = AIProxy.togetherAIDirectService(
    unprotectedAPIKey: "your-togetherAI-key"
)

/* Uncomment for all other production use cases */
//let togetherAIService = AIProxy.togetherAIService(
//    partialKey: "partial-key-from-your-developer-dashboard",
//    serviceURL: "service-url-from-your-developer-dashboard"
//)
