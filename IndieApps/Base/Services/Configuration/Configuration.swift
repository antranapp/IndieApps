//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

struct AppConfiguration {
    let mainContentRepositoryURL = URL(string: "https://github.com/antranapp/IndieAppsContent.git")!
    let rootFolderPath = FileManager.default.contentPath!
    let archiveURL = Bundle.main.url(forResource: "Archive", withExtension: ".zip")!
    
    let content: Content
    
    init() {
        content = Content(
            localURL: URL(string: rootFolderPath.combinePath(mainContentRepositoryURL.asValidPath))!,
            remoteURL: mainContentRepositoryURL
        )
    }
}

// MARK: Helpers Extensions

extension FileManager {
    var contentPath: String? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content").path
    }
}
