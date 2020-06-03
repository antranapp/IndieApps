//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    let name: String
}

let categoryList = [
    Category(name: "Movies"),
    Category(name: "Utilities"),
]
