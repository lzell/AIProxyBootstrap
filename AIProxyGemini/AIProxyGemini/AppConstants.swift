//
//  AppConstants.swift
//  AIProxyGemini
//
//  Created by Todd Hamilton on 10/18/24.
//

import AIProxy

#warning(
    """
    You must follow the AIProxy integration guide to build and run on device.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

let geminiService = AIProxy.geminiService(
    partialKey: "partial-key-from-your-developer-dashboard",
    serviceURL: "service-url-from-your-developer-dashboard"
)
