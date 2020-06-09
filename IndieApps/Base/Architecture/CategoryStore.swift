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
    var showSnackbar: Bool = false
    var snackbarData = SnackbarModifier.SnackbarData(title: "", detail: "", type: .info)
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
            return Effect(environment.contentService.fetchAppList(in: state.category))
                .receive(on: environment.mainQueue)
                .map { CategoryAction.setApps($0) }
                .catch { error -> AnyPublisher<CategoryAction, Never> in
                    return Just(CategoryAction.showError(error)).eraseToAnyPublisher()
                }
                .eraseToEffect()
        
        case .setApps(let apps):
            state.apps = apps
            return .none
        
        case .showError(let error):
            state.snackbarData = SnackbarModifier.SnackbarData.makeError(error: error)
            state.showSnackbar = true
            return .none
    }
}
.debug()
