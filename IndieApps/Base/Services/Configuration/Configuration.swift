//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

struct Configuration {
    
    struct Default {
        static let mainContentRepositoryURL = URL(string: "https://github.com/antranapp/IndieAppsContent.git")!
        static let rootFolderURL = FileManager.default.rootContentURL!
        static let archiveURL = Bundle.main.url(forResource: "Archive", withExtension: ".zip")!
    }
    
    let archiveURL: URL?
    let contentLocation: ContentLocation
    
    init(
        rootFolderURL: URL = Default.rootFolderURL,
        archiveURL: URL? = Default.archiveURL,
        remoteRepositoryURL: URL = Default.mainContentRepositoryURL
    ) {
        self.archiveURL = archiveURL
        contentLocation = ContentLocation(
            localURL: rootFolderURL.appendingPathComponent(remoteRepositoryURL.asValidPath),
            remoteURL: remoteRepositoryURL
        )
    }
}

// MARK: Helpers Extensions

extension FileManager {
    var rootContentURL: URL? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content")
    }
}
