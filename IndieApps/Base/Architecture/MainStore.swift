//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Files
import Combine
import Foundation

typealias MainStore = Store<MainState, MainAction>

struct AppEnvironment {
    var onboardingService: OnboardingServiceProtocol = OnboardingService()
    var gitService: GitServiceProtocol? = GitService(localRepositoryFolderPath: FileManager.default.contentPath!, remoteRepositoryURL: URL(string: "https://github.com/antranapp/IndieAppsContent.git")!)
    var contentService: ContentServiceProtocol = ContentService(rootFolderPath: FileManager.default.contentPath!)
}

// MARK: State

struct MainState: Equatable {
    
    var showSnackbar: Bool = false
    var snackbarData = SnackbarModifier.SnackbarData(title: "", detail: "", type: .info)
    var isDataAvailable: Bool = false
    var categoryList: [Category] = []
    var isNavigationActive: Bool = false
    
    var selection: CategoryState?
}

// MARK: Action

enum MainAction {
    case startOnboarding
    case endOnboarding
    case updateContent
    case resetContent
    case fetchCategories
    case setCategories([Category])
    case showError(Error)
    case showMessage(title: String, message: String, type: SnackbarModifier.SnackbarType)
    case hideSnackbar
    case goToOnboarding

    // For navigation to Category component
    case category(CategoryAction)
    case setNavigation(selection: Category?)
}

// MARK: Reducer

let appReducer = categoryReducer
    .optional
    .pullback(
        state: \MainState.selection,
        action: /MainAction.category,
        environment: { CategoryEnvironment(contentService: $0.contentService) }
    )
    .combined(
        with: Reducer<MainState, MainAction, AppEnvironment> { state, action, environment in
            switch action {
                case .startOnboarding:
                    return Effect(environment.onboardingService.unpackInitialContentIfNeeded())
                        .receive(on: RunLoop.main)
                        .map { MainAction.updateContent }
                        .catch { error in
                            return Just(MainAction.showError(error))
                    }
                    .eraseToEffect()
                
                case .endOnboarding:
                    state.isDataAvailable = true
                    return .none
                
                case .updateContent:
                    if let gitService = environment.gitService {
                        return Effect(gitService.update())
                            .receive(on: RunLoop.main)
                            .map { MainAction.endOnboarding }
                            .replaceError(with: MainAction.endOnboarding)
                            .eraseToEffect()
                    }
                    
                    return Effect(value: MainAction.endOnboarding)
                
                case .fetchCategories:
                    return Effect(environment.contentService.fetchCategoryList())
                        .receive(on: RunLoop.main)
                        .map { MainAction.setCategories($0) }
                        .eraseToEffect()
                
                case .setCategories(let categoryList):
                    state.categoryList = categoryList
                    return .none
                
                case .showMessage(let title, let message, let type):
                    state.snackbarData = SnackbarModifier.SnackbarData(title: title, detail: message, type: type)
                    state.showSnackbar = true
                    return .none
                
                case .showError(let error):
                    state.snackbarData.makeError(title: "Error!", detail: error.localizedDescription)
                    state.showSnackbar = true
                    return .none
                
                case .hideSnackbar:
                    state.showSnackbar = false
                    return .none
                
                case .resetContent:
                    if let gitService = environment.gitService {
                        return Effect(gitService.reset())
                            .receive(on: RunLoop.main)
                            .map { $0 ? MainAction.goToOnboarding : MainAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) }
                            .replaceError(with: MainAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) )
                            .eraseToEffect()
                    }
                    
                    return Effect(value: MainAction.goToOnboarding)
                
                case .goToOnboarding:
                    state.isDataAvailable = false
                    return .none
                
                case .category:
                    return .none
                
                case let .setNavigation(selection: .some(category)):
                    state.selection = CategoryState(category: category)
                    return .none

                case .setNavigation(selection: .none):
                    state.selection = nil
                    return .none
            }
        }
    )
    .debug()
    

// MARK: Helpers Extensions

extension FileManager {
    var contentPath: String? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content").path
    }
}
