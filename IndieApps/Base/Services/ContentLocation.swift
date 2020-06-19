//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

typealias ContentLocationProvider = () -> ContentLocation

struct ContentLocation: Equatable {
    let localURL: URL
    let remoteURL: URL
    let branch: String
}
