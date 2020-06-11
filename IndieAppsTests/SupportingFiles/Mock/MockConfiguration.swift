//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import Foundation

class MockConfiguration: ConfigurationProtocol {
    var archiveURL: URL? = Bundle(for: MockConfiguration.self).url(forResource: "ArchiveTest", withExtension: ".zip")!
    var contentLocation = ContentLocation(
        localURL: Configuration.Default.rootFolderURL.appendingPathComponent("test"),
        remoteURL:  Configuration.Default.mainContentRepositoryURL
    )
}
