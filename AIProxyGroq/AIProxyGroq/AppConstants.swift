//
//  AppConstants.swift
//  AIProxyGroq
//
//  Created by Todd Hamilton on 10/1/24.
//

import AIProxy

#warning(
    """
    Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

/* Uncomment for BYOK use cases */
// let groqService = AIProxy.groqDirectService(
//     unprotectedAPIKey: "your-groq-key"
// )

/* Uncomment for all other production use cases */
// let groqService = AIProxy.groqService(
//     partialKey: "partial-key-from-your-developer-dashboard",
//     serviceURL: "service-url-from-your-developer-dashboard"
// )
