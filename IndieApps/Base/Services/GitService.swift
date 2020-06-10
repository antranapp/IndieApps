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
    func clone(progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error>
    
    /// Update the content of a local repository from the remote.
    /// - Returns: Promise<Void>
    func update() -> Future<Void, Error>
    
    /// Delete the local repository.
    /// - Returns: Promise<Bool>
    func reset() -> Future<Bool, Error>
}

class GitService: GitServiceProtocol {
    
    // MARK: Properties
        
    // Public
    
    var localRepository: GTRepository?
    
    // Private
    
    private let content: Content
    private let fileManager = FileManager.default
    private let queue: DispatchQueue = DispatchQueue(label: "app.antran.indieapps.gitservice", qos: .userInitiated)
    private lazy var localRepositoryFolder = {
        try! Folder(path: content.localURL.path)
    }()
    
    // MARK: Initialization
    
    init(content: Content) {
        self.content = content
    }
    
    // MARK: APIs
    
    /// Clone the content repository to disk.
    /// - Returns: Future<Void, Error>
    func clone(progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    self.localRepository = try GTRepository.clone(
                        from: self.content.remoteURL,
                        toWorkingDirectory: self.content.localURL,
                        options: [GTRepositoryCloneOptionsTransportFlags: true],
                        transferProgressBlock: { progress, isFinished in
                        let progress = Float(progress.pointee.received_objects)/Float(progress.pointee.total_objects)
                        progressHandler(progress, isFinished.pointee.boolValue)
                    })                    
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
    func update() -> Future<Void, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    try self.openIfNeeded()
                    let branch = try self.localRepository!.currentBranch()
                    let remoteRepository = try GTRemote(name: "origin", in: self.localRepository!)
                    try self.localRepository!.pull(branch, from: remoteRepository, withOptions: nil, progress: nil)
                    promise(.success(()))
                } catch {
                    print(error)
                    promise(.failure(error))
                }
            }
        }
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
        print("GitServie \(content.localURL)")
        localRepository = try GTRepository(url: content.localURL)
    }
}

public enum GitServiceError: Error {
    case invalidURL
    case noLocalRepository
    case fileNotFound
}
