//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ZIPFoundation
import Combine
import Foundation

protocol OnboardingServiceProtocol {
    func unpackInitialContentIfNeeded() -> AnyPublisher<OnboardingState, Error>
}

enum OnboardingState {
    case unpackSucceed
    case noUnpackingDone
    case noUnpackingRequired
}

class OnboardingService: OnboardingServiceProtocol, CheckFileManager {
    
    private let contentLocation: ContentLocation
    private let archiveURL: URL?
    
    // MARK: Initialization
    
    init(archiveURL: URL?, contentLocation: ContentLocation) {
        self.archiveURL = archiveURL
        self.contentLocation = contentLocation
        
        print(contentLocation.localURL.absoluteString)
    }

    // MARK: APIs
    
    func unpackInitialContentIfNeeded() -> AnyPublisher<OnboardingState, Error> {
        DispatchQueue.global().publisher { promise in
            do {
                let state = try self.unpackContent()
                promise(.success(state))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    // MARK: Private helpers
    
    private func unpackContent() throws -> OnboardingState {
        
        guard !isCheckFileAvailable(at: contentLocation.localURL) else {
            return .noUnpackingRequired
        }
        
        // Only unpack content for default repository & master branch
        guard contentLocation.localURL == Configuration.Default.remoteRepositoryURL &&
            contentLocation.branch == Configuration.Default.branch else {
                return .noUnpackingDone
        }
        
        let fileManager = FileManager.default
        
        try fileManager.createDirectory(
            at: contentLocation.localURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        guard let archiveURL = archiveURL else {
            return .noUnpackingDone
        }
        
        try fileManager.unzipItem(
            at: archiveURL,
            to: contentLocation.localURL
        )
        
        try writeCheckFile(at: contentLocation.localURL)
        
        return .unpackSucceed
    }
}

enum OnboardingServiceError: Error {
    case ioException
    case failedToUnpackInitialContent
}
