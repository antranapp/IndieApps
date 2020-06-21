//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import Foundation
import ZIPFoundation

protocol OnboardingServiceProtocol {
    func unpackInitialContentIfNeeded() -> AnyPublisher<OnboardingState, Error>
}

enum OnboardingState {
    case unpackSucceed
    case noUnpackingDone
    case noUnpackingRequired
}

class OnboardingService: OnboardingServiceProtocol, CheckFileManager {
    private let contentLocationProvider: ContentLocationProvider
    private let archiveURL: URL?

    private var localURL: URL {
        contentLocationProvider().localURL
    }

    private var remoteURL: URL {
        contentLocationProvider().remoteURL
    }

    private var branch: String {
        contentLocationProvider().branch
    }

    // MARK: Initialization

    init(archiveURL: URL?, contentLocationProvider: @escaping ContentLocationProvider) {
        self.archiveURL = archiveURL
        self.contentLocationProvider = contentLocationProvider

        print(localURL.absoluteString)
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
        guard !isCheckFileAvailable(at: localURL) else {
            return .noUnpackingRequired
        }

        // Only unpack content for default repository & master branch
        guard remoteURL == Configuration.Default.remoteRepositoryURL,
            branch == Configuration.Default.branch else {
            return .noUnpackingDone
        }

        let fileManager = FileManager.default

        try fileManager.createDirectory(
            at: localURL,
            withIntermediateDirectories: true,
            attributes: nil
        )

        guard let archiveURL = archiveURL else {
            return .noUnpackingDone
        }

        try fileManager.unzipItem(
            at: archiveURL,
            to: localURL
        )

        try writeCheckFile(at: localURL)

        return .unpackSucceed
    }
}

enum OnboardingServiceError: Error {
    case ioException
    case failedToUnpackInitialContent
}
