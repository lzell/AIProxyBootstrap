//
//  ModelContext+Extensions.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation
import SwiftData

extension ModelContext {

    /// Deletes all models in `AppConstants.swiftDataModels` from SwiftData.
    /// Use this during development to return to a clean slate.
    func reset() {
        do {
            for model in AppConstants.swiftDataModels {
                try self.delete(model: model)
            }
        } catch {
            AppLogger.error("Failed to reset swift data for all models. Error: \(error.localizedDescription)")
        }
    }
}
