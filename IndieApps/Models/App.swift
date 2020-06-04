//
//  Copyright © 2020 An Tran. All rights reserved.
//

import UIKit
import Foundation

struct App: Identifiable, Decodable {
    var id: String
    var icon: UIImage? = nil
    var name: String
    var shortDescription: String
    var description: String
    var releaseNotes: [ReleaseNote]

    private enum CodingKeys: String, CodingKey {
        case id, name, shortDescription, description, releaseNotes
    }
}

struct ReleaseNote: Identifiable, Decodable {
    var id: String
    var version: String
    var note: String
}
