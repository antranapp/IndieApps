//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import Foundation

struct World {
    var service = ContentService()
}

enum AppAction {
    case fetchCategoryList
    case setCategoryList(_ categoryList: [Category])
}

struct AppState {
    var categoryList: [Category] = []
}

typealias AppStore = Store<AppState, AppAction, World>
