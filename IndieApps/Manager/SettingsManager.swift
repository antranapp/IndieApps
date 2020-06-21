//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

class SettingsManager {

    //var configuration: Configuration = Configuration()

    var configuration: Configuration!

    @UserDefault(.remoteRepositoryURL, defaultValue: Configuration.Default.remoteRepositoryURL.absoluteString)
    var remoteRepositoryURLString: String

    var remoteRepositoryURL: URL {
        URL(string: remoteRepositoryURLString)!
    }

    @UserDefault(.branch, defaultValue: Configuration.Default.branch)
    var branch: String

    var observations = [AnyObject]()

    init() {
        let obs1 = $remoteRepositoryURLString.observe { [weak self] (_, new) in
            guard let self = self else { return }
            if let new = new {
                self.configuration = Configuration(
                    remoteRepositoryURL: URL(string: new)!,
                    branch: self.branch
                )
            } else {
                self.configuration = Configuration()
            }
        }
        observations.append(obs1)

        let obs2 = $branch.observe { [weak self] (_, new) in
            guard let self = self else { return }
            if let new = new {
                self.configuration = Configuration(
                    remoteRepositoryURL: URL(string: self.remoteRepositoryURLString)!,
                    branch: new
                )
            } else {
                self.configuration = Configuration()
            }
        }
        observations.append(obs2)

        configuration = Configuration(
            remoteRepositoryURL: remoteRepositoryURL,
            branch: branch
        )
    }

    func update(remoteRepositoryURLString: String?) {
        _remoteRepositoryURLString.wrappedValue = remoteRepositoryURLString ?? Configuration.Default.remoteRepositoryURL.absoluteString

    }

    func update(branch: String?) {
        _branch.wrappedValue = branch ?? Configuration.Default.branch
    }

    func reset() {
        update(remoteRepositoryURLString: Configuration.Default.remoteRepositoryURL.absoluteString)
        update(branch: Configuration.Default.branch)
    }
}

extension Key {
    static let remoteRepositoryURL: Key = Key(rawValue: "remoteRepositoryURL")
    static let branch: Key = Key(rawValue: "branch")
}
