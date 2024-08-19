//
//  AppConstants.swift
//  AIProxyAnthropic
//
//  Created by Todd Hamilton on 8/14/24.
//

import AIProxy

#warning(
    """
    You must follow the AIProxy integration guide to build and run on device.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

let anthropicService = AIProxy.anthropicService(
    partialKey: "partial-key-from-your-developer-dashboard",
    serviceURL: "service-url-from-your-developer-dashboard"
)
