//
//  FileUtils.swift
//  AIProxyBootstrap
//
//  Created by Lou Zell
//

import Foundation


struct FileUtils {
    private init() {
        fatalError("FileUtils is a namespace only")
    }

    static func getDocumentsURL() -> URL {
        guard let documentsUrl = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first
        else {
            fatalError("Could could not find the Documents directory")
        }
        return documentsUrl
    }

    static func getFileURL() -> URL {
        let documentsUrl = self.getDocumentsURL()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        isoFormatter.timeZone = .current

        var dateString = isoFormatter.string(from: Date())
        dateString = dateString.replacingOccurrences(of: ":", with: ".")
        let filename = "AIProxyBootstrap-\(dateString).m4a"

        return documentsUrl.appendingPathComponent(filename)
    }

    static func deleteFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            AppLogger.info("Could not find file to delete at \(url)")
        }
    }
}
