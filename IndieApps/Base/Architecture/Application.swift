//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Files
import Combine
import Foundation

typealias AppStore = Store<AppState, AppAction>

struct AppEnvironment {
    var onboardingService: OnboardingServiceProtocol = OnboardingService()
    var gitService: GitServiceProtocol? = GitService(localRepositoryFolderPath: FileManager.default.contentPath!, remoteRepositoryURL: URL(string: "https://github.com/antranapp/IndieAppsContent.git")!)
    var contentService: ContentServiceProtocol = ContentService(rootFolderPath: FileManager.default.contentPath!)
}

// MARK: State

struct AppState: Equatable {
    
    var showSnackbar: Bool = false
    var snackbarData = SnackbarModifier.SnackbarData(title: "", detail: "", type: .info)
    var isDataAvailable: Bool = false
    var categoryList: [Category] = []
    var appList: [App] = []
    
    mutating func reset() {
        isDataAvailable = false
        categoryList = []
        appList = []
    }
}

// MARK: Action

enum AppAction {
    case startOnboarding
    case endOnboarding
    case updateContent
    case resetContent
    case fetchCategoryList
    case setCategoryList(_ categoryList: [Category])
    case fetchAppList(_ category: Category)
    case setAppList(_ appList: [App])
    case showError(_ error: Error)
    case showMessage(title: String, message: String, type: SnackbarModifier.SnackbarType)
    case hideSnackbar
    case goToOnboarding
}

// MARK: Reducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
        case .startOnboarding:
            return Effect(environment.onboardingService.unpackInitialContentIfNeeded())
                .receive(on: RunLoop.main)
                .map { AppAction.updateContent }
                .catch { error in
                    return Just(AppAction.showError(error))
                }
                .eraseToEffect()
        
        case .endOnboarding:
            state.isDataAvailable = true
            return .none
        
        case .updateContent:
            if let gitService = environment.gitService {
                return Effect(gitService.update())
                    .receive(on: RunLoop.main)
                    .map { AppAction.endOnboarding }
                    .replaceError(with: AppAction.endOnboarding)
                    .eraseToEffect()
            }
            
            return Effect(value: AppAction.endOnboarding)

        case .fetchCategoryList:
            return Effect(environment.contentService.fetchCategoryList())
                .receive(on: RunLoop.main)
                .map { AppAction.setCategoryList($0) }
                .eraseToEffect()
        
        case .setCategoryList(let categoryList):
            state.categoryList = categoryList
            return .none
        
        case .fetchAppList(let category):
            return Effect(environment.contentService.fetchAppList(in: category))
                .receive(on: RunLoop.main)
                .map { AppAction.setAppList($0) }
                .eraseToEffect()
        
        case .setAppList(let appList):
            state.appList = appList
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
                    .map { $0 ? AppAction.goToOnboarding : AppAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) }
                    .replaceError(with: AppAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) )
                    .eraseToEffect()
            }
            
            return Effect(value: AppAction.goToOnboarding)
        
        case .goToOnboarding:
            state.isDataAvailable = false
            return .none
    }
}

// MARK: Helpers Extensions

extension FileManager {
    var contentPath: String? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content").path
    }
}
