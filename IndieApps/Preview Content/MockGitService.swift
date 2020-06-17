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
    
    func clone(branchName: String?, progressHandler: @escaping (Float, Bool) -> Void) -> Future<Void, Error> {
        return Future { $0(.success(())) }
    }

    func checkoutAndUpdate(branchName: String) -> AnyPublisher<Void, Error> {
        return Future { $0(.success(())) }.eraseToAnyPublisher()
    }
    
    func reset() -> Future<Bool, Error> {
        return Future { $0(.success(true)) }
    }
}
#endif
