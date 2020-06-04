//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import Foundation

struct World {
    var onboardingService = OnboardingService()
    var contentService = ContentService()
}

enum AppAction {
    case startOnboarding
    case fetchCategoryList
    case setCategoryList(_ categoryList: [Category])
}

struct AppState {
    var isDataAvailable: Bool = false
    var categoryList: [Category] = []
}

typealias AppStore = Store<AppState, AppAction, World>
