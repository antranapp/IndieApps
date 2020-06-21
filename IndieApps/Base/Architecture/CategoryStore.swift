//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

typealias CategoryStore = Store<CategoryState, CategoryAction>

struct CategoryState: Equatable {
    var category: Category
    var apps: [App]?
    var snackbarData: SnackbarModifier.SnackbarData?
}

enum CategoryAction {
    case fetchApps
    case setApps([App])
    case showError(Error)
}

extension CategoryAction: Equatable {
    static func == (lhs: CategoryAction, rhs: CategoryAction) -> Bool {
        switch (lhs, rhs) {
        case (.fetchApps, .fetchApps):
            return true
        case let (.setApps(lApps), .setApps(rApps)):
            return lApps == rApps
        case let (.showError(lError), .showError(rError)):
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

    case let .setApps(apps):
        state.apps = apps
        return .none

    case let .showError(error):
        state.snackbarData = SnackbarModifier.SnackbarData.makeError(error: error)
        return .none
    }
}
