//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
import Files
import ObjectiveGit
import Combine

struct MockGitService: GitServiceProtocol {
    
    var localRepositoryFolder = try! Folder(path: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path)
    var localRepository: GTRepository? = nil
    
    func clone(progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error> {
        return Future { $0(.success(())) }
    }
    
    func update() -> Future<Void, Error> {
        return Future { $0(.success(())) }
    }
    
    func reset() -> Future<Bool, Error> {
        return Future { $0(.success(true)) }
    }
}
#endif
