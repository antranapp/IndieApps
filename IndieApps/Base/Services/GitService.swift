//
//  Copyright © 2019 An Tran. All rights reserved.
//

import Files
import ObjectiveGit
import Combine

public protocol GitServiceProtocol {
    
    var localRepository: GTRepository? { get set }
    
    /// Clone the content repository to disk.
    /// - Returns: Promise<Void>
    func clone(branchName: String?, progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error>
    
    /// Update the content of a local repository from the remote.
    /// - Returns: Promise<Void>
    func checkoutAndUpdate(branchName: String) -> AnyPublisher<Void, Error>
    
    /// Delete the local repository.
    /// - Returns: Promise<Bool>
    func reset() -> Future<Bool, Error>
}

class GitService: GitServiceProtocol, CheckFileManager {
    
    // MARK: Properties
        
    // Public
    
    var localRepository: GTRepository?
    
    // Private
    
    private let contentLocation: ContentLocation
    private let fileManager = FileManager.default
    private let queue: DispatchQueue = DispatchQueue(label: "app.antran.indieapps.gitservice", qos: .userInitiated)
    private lazy var localRepositoryFolder = {
        try! Folder(path: contentLocation.localURL.path)
    }()
    
    // MARK: Initialization
    
    init(contentLocation: ContentLocation) {
        self.contentLocation = contentLocation
    }
    
    // MARK: APIs
    
    /// Clone the content repository to disk.
    /// - Returns: Future<Void, Error>
    func clone(branchName: String?, progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    self.localRepository = try GTRepository.clone(
                        from: self.contentLocation.remoteURL,
                        toWorkingDirectory: self.contentLocation.localURL,
                        options: [
                            GTRepositoryCloneOptionsTransportFlags: true,
                            GTRepositoryCloneOptionsPerformCheckout: false
                        ],
                        transferProgressBlock: { progress, isFinished in
                            let received = Float(progress.pointee.received_objects)
                            let total = Float(progress.pointee.total_objects)
                            let progress = received/total
                            let boolValue = isFinished.pointee.boolValue
                            progressHandler(progress, boolValue)
                        }
                    )
                    
                    try? self.writeCheckFile(at: self.contentLocation.localURL)
                    promise(.success(()))

                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
    }
    
    private func checkoutBranch(branchName: String) -> Future<Void, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    try self.openIfNeeded()
                    guard let localRepository = self.localRepository else {
                        throw GitServiceError.noLocalRepository
                    }
                    
                    print("try to checkout \(branchName)")
                    let head = try localRepository.headReference()
                    
                    if branchName == "master" {
                        try localRepository.checkoutReference(head, options: nil)
                    } else {
                        let remoteRepository = try GTRemote(name: "origin", in: localRepository)
                        try localRepository.fetch(remoteRepository, withOptions: nil, progress: nil)
                        
                        let branches = try localRepository.branches()
                        let localBranchOrNil = branches.first { $0.name == branchName }
                        let remoteBranchOrNil = branches.first { $0.name == "origin/\(branchName)" }

                        var localBranch: GTBranch!
                        if localBranchOrNil == nil { // no local branch found
                            guard let remoteBranch = remoteBranchOrNil else {
                                throw GitServiceError.remoteBranchNotFound
                            }
                            print(remoteBranch)
                            localBranch = try localRepository.createBranchNamed(
                                branchName,
                                from: remoteBranch.reference.oid!,
                                message: nil
                            )
                            try localBranch.updateTrackingBranch(remoteBranch)
                        } else {
                            localBranch = localBranchOrNil!
                        }
                        
                        let options = GTCheckoutOptions(strategy: GTCheckoutStrategyType.force)
                        try localRepository.checkoutReference(localBranch.reference, options: options)
                        try localRepository.moveHEAD(to: localBranch.reference)
                        _ = try? localRepository.stashChanges(withMessage: nil, flags: GTRepositoryStashFlag(rawValue: 0))
                    }

                    promise(.success(()))
                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
    }
    
    
    /// Pull update of the remote repository to disk.
    /// - Returns: Future<Void, Error>
    private func update() -> Future<Void, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    try self.openIfNeeded()
                    guard let localRepository = self.localRepository else {
                        throw GitServiceError.noLocalRepository
                    }

                    let branch = try localRepository.currentBranch()
                    let remoteRepository = try GTRemote(name: "origin", in: localRepository)
                    try localRepository.pull(branch, from: remoteRepository, withOptions: nil, progress: nil)
                    promise(.success(()))
                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
    }
    
    func checkoutAndUpdate(branchName: String) -> AnyPublisher<Void, Error> {
        return checkoutBranch(branchName: branchName)
            .flatMap { self.update() }
            .eraseToAnyPublisher()
    }
    
    /// Remove the local repository folder and clone the data again.
    /// - Returns: Future<Void, Error>
    func reset() -> Future<Bool, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    try self.localRepositoryFolder.delete()
                    promise(.success(true))
                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
    }
    
    // MARK: Private helpers
    
    private func openIfNeeded() throws {
        guard localRepository == nil else {
            return
        }
        
        // Check if local repository is available
        localRepository = try GTRepository(url: contentLocation.localURL)
    }
}

public enum GitServiceError: Error {
    case invalidURL
    case noLocalRepository
    case fileNotFound
    case remoteBranchNotFound
}
