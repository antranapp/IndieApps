//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Foundation

typealias CategoryStore = Store<CategoryState, CategoryAction>

struct CategoryState: Equatable, Hashable {
    var category: Category
    var apps: [App] = []
}

enum CategoryAction {
    case fetchApps
    case setApps([App])
}

struct CategoryEnvironment {
    var contentService: ContentServiceProtocol
}

let categoryReducer = Reducer<CategoryState, CategoryAction, CategoryEnvironment> { state, action, environment in
    switch action {
        case .fetchApps:
            return Effect(environment.contentService.fetchAppList(in: state.category))
                .receive(on: RunLoop.main)
                .map { CategoryAction.setApps($0) }
                .eraseToEffect()
        
        case .setApps(let apps):
            state.apps = apps
            return .none
    }
}
.debug()
