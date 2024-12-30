//
//  AppConstants.swift
//  FilmFinder
//
//  Created by Todd Hamilton on 11/4/24.
//

import AIProxy

#warning(
    """
    Uncomment one of the methods below. To build and run on device you must follow the AIProxy integration guide.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    
    You will also need a read access token from TMDB:
    https://developer.themoviedb.org/docs/getting-started
    """
)

/* Uncomment for BYOK use cases */
let groqService = AIProxy.groqDirectService(
    unprotectedAPIKey: "your-groq-key"
)

/* Uncomment for all other production use cases */
// static let groqService = AIProxy.groqService(
//     partialKey: "partial-key-from-your-developer-dashboard",
//     serviceURL: "service-url-from-your-developer-dashboard"
// )

let tmdb = "api-read-access-token-from-tmdb"
