//
//  AppLogger.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import OSLog

/// Log levels available:
///
///     AppLogger.debug
///     AppLogger.info
///     AppLogger.warning
///     AppLogger.error
///     AppLogger.critical
///
/// Flip on metadata logging in Xcode's console to show which source line the log occurred from.
///
/// See my reddit post for a video instructions:
/// https://www.reddit.com/r/SwiftUI/comments/15lsdtk/how_to_use_the_oslog_logger/
let AppLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "UnknownApp",
                       category: "AIProxyBootstrapTrivia")
