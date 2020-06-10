//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ZIPFoundation
import Combine
import Foundation

protocol OnboardingServiceProtocol {
    func unpackInitialContentIfNeeded() -> AnyPublisher<Void, Error>
}

class OnboardingService: OnboardingServiceProtocol {
    
    private let content: Content
    private let archiveURL: URL
    
    // MARK: Initialization
    
    init(archiveURL: URL, content: Content) {
        self.archiveURL = archiveURL
        self.content = content
    }

    // MARK: APIs
    
    func unpackInitialContentIfNeeded() -> AnyPublisher<Void, Error> {
        DispatchQueue.global().publisher { promise in
            do {
                try self.unpackContent()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    // MARK: Private helpers
    
    private func unpackContent() throws {
        let fileManager = FileManager.default

        let checkFileURL = content.localURL.appendingPathComponent("version").appendingPathExtension("txt")
        
        guard !fileManager.fileExists(atPath: checkFileURL.path) else {
            return
        }
        
        try fileManager.createDirectory(at: content.localURL, withIntermediateDirectories: true, attributes: nil)
        try fileManager.unzipItem(at: archiveURL, to: content.localURL)
        try "\(Date())".write(to: checkFileURL, atomically: true, encoding: .utf8)
    }
}


enum OnboardingServiceError: Error {
    case ioException
    case failedToUnpackInitialContent
}
