//
//  AppConstants.swift
//  AIProxyOpenAI
//
//  Created by Todd Hamilton on 6/14/24.
//

import AIProxy

#warning(
    """
    You must follow the AIProxy integration guide to build and run on device.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

let openAIService = AIProxy.openAIService(
    partialKey: "partial-key-from-your-developer-dashboard",
    serviceURL: "service-url-from-your-developer-dashboard"
)
