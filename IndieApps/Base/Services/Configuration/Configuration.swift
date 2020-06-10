//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

struct AppConfiguration {
    let mainContentRepositoryURL = URL(string: "https://github.com/antranapp/IndieAppsContent.git")!
    let rootFolderURL = FileManager.default.rootContentURL!
    let archiveURL = Bundle.main.url(forResource: "Archive", withExtension: ".zip")!
    
    let contentLocation: ContentLocation
    
    init() {
        contentLocation = ContentLocation(
            localURL: rootFolderURL.appendingPathComponent(mainContentRepositoryURL.asValidPath),
            remoteURL: mainContentRepositoryURL
        )
    }
}

// MARK: Helpers Extensions

extension FileManager {
    var rootContentURL: URL? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content")
    }
}
