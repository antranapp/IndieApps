//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Combine
import Foundation

typealias CategoryStore = Store<CategoryState, CategoryAction>

struct CategoryState: Equatable {
    var category: Category
    var apps: [App]? = nil
    var snackbarData: SnackbarModifier.SnackbarData?
}

enum CategoryAction  {
    case fetchApps
    case setApps([App])
    case showError(Error)
}

extension CategoryAction: Equatable {
    static func == (lhs: CategoryAction, rhs: CategoryAction) -> Bool {
        switch (lhs, rhs) {
            case (.fetchApps, .fetchApps):
                return true
            case (.setApps(let lApps), .setApps(let rApps)):
                return lApps == rApps
            case (.showError(let lError), .showError(let rError)):
                return lError._code == rError._code
            default:
                return false
        }
    }
}

struct CategoryEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var contentService: ContentServiceProtocol
}

let categoryReducer = Reducer<CategoryState, CategoryAction, CategoryEnvironment> { state, action, environment in
    switch action {
        case .fetchApps:
            state.apps = nil
            state.snackbarData = nil
            return Effect(environment.contentService.fetchAppList(in: state.category))
                .receive(on: environment.mainQueue)
                .map { CategoryAction.setApps($0) }
                .catch {
                    Just(CategoryAction.showError($0))
                }
                .eraseToEffect()
        
        case .setApps(let apps):
            state.apps = apps
            return .none
        
        case .showError(let error):
            state.snackbarData = SnackbarModifier.SnackbarData.makeError(error: error)
            return .none
    }
}
