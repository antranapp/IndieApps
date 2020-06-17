//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

protocol ConfigurationProtocol {
    var archiveURL: URL? { get }
    var contentLocation: ContentLocation { get }
}

struct Configuration: ConfigurationProtocol {
    
    struct Default {
        static let remoteRepositoryURL = URL(string: "https://github.com/antranapp/IndieAppsContent.git")!
        static let rootFolderURL = FileManager.default.rootContentURL!
        static let archiveURL = Bundle.main.url(forResource: "Archive", withExtension: ".zip")!
        static let branch = "master"
    }
    
    let archiveURL: URL?
    let contentLocation: ContentLocation
    
    init(
        rootFolderURL: URL = Default.rootFolderURL,
        archiveURL: URL? = Default.archiveURL,
        remoteRepositoryURL: URL = Default.remoteRepositoryURL,
        branch: String = Default.branch
    ) {
        self.archiveURL = archiveURL
        contentLocation = ContentLocation(
            localURL: rootFolderURL
                        .appendingPathComponent(remoteRepositoryURL.asValidPath.lowercased())
                        .appendingPathComponent(branch),
            remoteURL: remoteRepositoryURL,
            branch: branch
        )
    }
    
}

// MARK: Helpers Extensions

extension FileManager {
    
    var rootContentURL: URL? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content")
    }
    
}
