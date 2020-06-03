//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

struct App: Identifiable {
    var id = UUID()
    var name: String
    var shortDescription: String
    var description: String
    var releaseNotes: [ReleaseNote]
}

struct ReleaseNote: Identifiable {
    var id = UUID()
    var version: String
    var note: String
}
