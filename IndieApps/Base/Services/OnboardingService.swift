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
    
    func unpackInitialContentIfNeeded() -> AnyPublisher<Void, Error> {
        DispatchQueue.global().publisher { promise in
            do {
                try self.unpackContent()
                promise(.success(()))
            } catch {
                promise(.failure(OnboardingServiceError.failedToUnpackInitialContent))
            }
        }
    }
    
    // MARK: Private helpers
    
    private func unpackContent() throws {
        let fileManager = FileManager.default
        guard let sourceURL = Bundle.main.url(forResource: "Archive", withExtension: "zip"),
              var destinationURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw OnboardingServiceError.ioException
        }
        destinationURL.appendPathComponent("content")

        let checkFileURL = destinationURL.appendingPathComponent("version").appendingPathExtension("txt")
        
        guard !fileManager.fileExists(atPath: checkFileURL.path) else {
            return
        }
        
        try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        try fileManager.unzipItem(at: sourceURL, to: destinationURL)
        try "\(Date())".write(to: checkFileURL, atomically: true, encoding: .utf8)
    }
}


enum OnboardingServiceError: Error {
    case ioException
    case failedToUnpackInitialContent
}
