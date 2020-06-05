//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

struct Category: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let numberOfApps: Int
}
