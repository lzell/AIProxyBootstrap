//
//  AppConstants.swift
//  FilmFinder
//
//  Created by Todd Hamilton on 11/4/24.
//

import AIProxy

#warning(
    """
    You must follow the AIProxy integration guide to build and run on device.
    Please see https://www.aiproxy.pro/docs/integration-guide.html")
    
    You will also need a read access token from TMDB:
    https://developer.themoviedb.org/docs/getting-started
    """
)

let groqService = AIProxy.groqService(
    partialKey: "partial-key-from-your-developer-dashboard",
    serviceURL: "service-url-from-your-developer-dashboard"
)

let tmdb = "api-read-access-token-from-tmdb"
