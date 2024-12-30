//
//  AppConstants.swift
//  AIProxyDeepL
//
//  Created by Todd Hamilton on 8/14/24.
//

import AIProxy

#warning(
    """
    Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

/* Uncomment for BYOK use cases */
// let deepLService = AIProxy.deepLDirectService(
//     unprotectedAPIKey: "your-deepL-key",
//     accountType: .free
// )

/* Uncomment for all other production use cases */
// let service = AIProxy.deepLService(
//     partialKey: "partial-key-from-your-developer-dashboard",
//     serviceURL: "service-url-from-your-developer-dashboard"
// )
