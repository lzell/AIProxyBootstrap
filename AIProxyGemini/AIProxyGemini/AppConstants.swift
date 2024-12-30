//
//  AppConstants.swift
//  AIProxyGemini
//
//  Created by Todd Hamilton on 10/18/24.
//

import AIProxy

#warning(
    """
    Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

/* Uncomment for BYOK use cases */
// let geminiService = AIProxy.geminiDirectService(
//     unprotectedAPIKey: "your-gemini-key"
// )

/* Uncomment for all other production use cases */
// let geminiService = AIProxy.geminiService(
//     partialKey: "partial-key-from-your-developer-dashboard",
//     serviceURL: "service-url-from-your-developer-dashboard"
// )
