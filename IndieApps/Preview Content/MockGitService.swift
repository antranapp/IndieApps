//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
    import Combine
    import Files
    import ObjectiveGit

    struct MockGitService: GitServiceProtocol {
        var localRepositoryFolder = try! Folder(path: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path)
        var localRepository: GTRepository?

        func clone(branchName _: String?, progressHandler _: @escaping (Float, Bool) -> Void) -> Future<Void, Error> {
            return Future { $0(.success(())) }
        }

        func checkoutAndUpdate(branchName _: String) -> AnyPublisher<Void, Error> {
            return Future { $0(.success(())) }.eraseToAnyPublisher()
        }

        func reset() -> Future<Bool, Error> {
            return Future { $0(.success(true)) }
        }
    }
#endif
