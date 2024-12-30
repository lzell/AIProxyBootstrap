//
//  AppConstants.swift
//  PuLIDDemo
//
//  Created by Todd Hamilton on 9/28/24.
//

import AIProxy

#error(
    """
    Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    """
)

/* Uncomment for BYOK use cases */
let replicateService = AIProxy.replicateDirectService(
    unprotectedAPIKey: "your-replicate-key"
)

/* Uncomment for all other production use cases */
//let replicateService = AIProxy.replicateService(
//    partialKey: "partial-key-from-your-developer-dashboard",
//    serviceURL: "service-url-from-your-developer-dashboard"
//)
