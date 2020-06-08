//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Files
import Combine
import Foundation

typealias AppStore = Store<AppState, AppAction>

class World {
    var onboardingService: OnboardingServiceProtocol = OnboardingService()
    
    // Making the following variables lazy to ensure that we have a `content` folder after `Onboarding`.
    lazy var gitService: GitServiceProtocol? = GitService(localRepositoryFolder: rootContentFolder, remoteRepositoryURL: URL(string: "https://github.com/antranapp/IndieAppsContent.git")!)
    lazy var contentService: ContentServiceProtocol = ContentService(rootFolder: rootContentFolder)
    lazy var rootContentFolder: Folder = try! Folder(path: FileManager.default.contentPath!)
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
    
//    static func == (lhs: AppState, rhs: AppState) -> Bool {
//        return lhs.showSnackbar = rhs.showSnackbar &&
//
//    }

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

let appReducer = Reducer<AppState, AppAction, World> { state, action, environment in
    switch action {
        case .startOnboarding:
            return Effect(environment.onboardingService.unpackInitialContentIfNeeded())
                .map { AppAction.updateContent }
                .catch { error in
                    return Just(AppAction.showError(error))
                }
                .eraseToEffect()
//            return environment.onboardingService
//                .unpackInitialContentIfNeeded()
//                .receive(on: RunLoop.main)
//                .map { AppAction.updateContent }
//                .catch { error in
//                    return Just(AppAction.showError(error))
//            }
//            .eraseToAnyPublisher()
        
        case .endOnboarding:
            state.isDataAvailable = true
            return .none
        
        case .updateContent:
            if let gitService = environment.gitService {
                return Effect(gitService.update())
                    .map { AppAction.endOnboarding }
                    .replaceError(with: AppAction.endOnboarding)
                    .eraseToEffect()
            }
            
            return Effect(value: AppAction.endOnboarding)

//            return environment.gitService?
//                .update()
//                .map { AppAction.endOnboarding }
//                .replaceError(with: AppAction.endOnboarding)
//                .eraseToAnyPublisher()
        
        case .fetchCategoryList:
//            return environment.contentService
//                .fetchCategoryList()
//                .map { AppAction.setCategoryList($0)}
//                .eraseToAnyPublisher()
            return .none
        
        case .setCategoryList(let categoryList):
            state.categoryList = categoryList
            return .none
        
        case .fetchAppList(let category):
//            return environment.contentService
//                .fetchAppList(in: category)
//                .map { AppAction.setAppList($0)}
//                .eraseToAnyPublisher()
            return .none
        
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
//            return environment.gitService?
//                .reset()
//                .receive(on: RunLoop.main)
//                .map { $0 ? AppAction.goToOnboarding : AppAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) }
//                .replaceError(with: AppAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) )
//                .eraseToAnyPublisher()
            return .none
        
        case .goToOnboarding:
            state.isDataAvailable = false
            return .none
    }
}
.debug()

// MARK: Helpers Extensions

extension FileManager {
    var contentPath: String? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content").path
    }
}
