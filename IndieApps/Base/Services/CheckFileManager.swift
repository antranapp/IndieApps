//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

protocol CheckFileManager {
    func isCheckFileAvailable(at url: URL) -> Bool
    func writeCheckFile(at url: URL) throws
}

extension CheckFileManager {
    func isCheckFileAvailable(at url: URL) -> Bool {
        let fileManager = FileManager.default
        let checkFileURL = url.appendingPathComponent("version").appendingPathExtension("txt")
        if fileManager.fileExists(atPath: checkFileURL.path) {
            return true
        }

        return false
    }

    func writeCheckFile(at url: URL) throws {
        let checkFileURL = url.appendingPathComponent("version").appendingPathExtension("txt")
        try "\(Date())".write(to: checkFileURL, atomically: true, encoding: .utf8)
    }
}
