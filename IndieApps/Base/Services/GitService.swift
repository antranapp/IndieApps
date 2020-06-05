//
//  Copyright © 2019 An Tran. All rights reserved.
//

import Files
import ObjectiveGit
import Combine

public protocol GitServiceProtocol {
    
    var localRepositoryFolder: Folder { get }
    var localRepository: GTRepository? { get set }
    
    func open() -> Bool
    
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
    var localRepositoryFolder: Folder
    
    // Private
    
    private let remoteRepositoryURL: URL
    
    private let fileManager = FileManager.default
    
    private let queue: DispatchQueue
    
    // MARK: Initialization
    
    public init?(localRepositoryFolder: Folder, remoteRepositoryURL: URL) {
        self.localRepositoryFolder = localRepositoryFolder
        self.remoteRepositoryURL = remoteRepositoryURL
        
        queue = DispatchQueue(label: "app.antran.indieapps.gitservice", qos: .userInitiated)
        print("GitServie \(localRepositoryFolder.url)")
        
        if !open() {
            return nil
        }
    }
    
    // MARK: APIs
    
    /// Prepare the repository on local disk for displaying content.
    /// - Returns: Bool
    public func open() -> Bool {
                
        // Check if local repository is available
        do {
            localRepository = try GTRepository(url: localRepositoryFolder.url)
        } catch {
            return false
        }
        
        return true
    }
    
    /// Clone the content repository to disk.
    /// - Returns: Future<Void, Error>
    public func clone(progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    self.localRepository = try GTRepository.clone(from: self.remoteRepositoryURL, toWorkingDirectory: self.localRepositoryFolder.url, options: [GTRepositoryCloneOptionsTransportFlags: true], transferProgressBlock: { progress, isFinished in
                        let progress = Float(progress.pointee.received_objects)/Float(progress.pointee.total_objects)
                        progressHandler(progress, isFinished.pointee.boolValue)
                    })                    
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    /// Pull update of the remote repository to disk.
    /// - Returns: Future<Void, Error>
    public func update() -> Future<Void, Error> {
        return Future { promise in
            guard let localRepository = self.localRepository else {
                promise(.failure(GitServiceError.noLocalRepository))
                return
            }
            
            self.queue.async {
                do {
                    let branch = try localRepository.currentBranch()
                    let remoteRepository = try GTRemote(name: "origin", in: localRepository)
                    try localRepository.pull(branch, from: remoteRepository, withOptions: nil, progress: nil)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    /// Remove the local repository folder and clone the data again.
    /// - Returns: Future<Void, Error>
    public func reset() -> Future<Bool, Error> {
        return Future { promise in
            self.queue.async {
                do {
                    try self.localRepositoryFolder.delete()
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

public enum GitServiceError: Error {
    case invalidURL
    case noLocalRepository
    case fileNotFound
}
