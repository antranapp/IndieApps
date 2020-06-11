//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Files
import Combine
import Foundation

typealias MainStore = Store<MainState, MainAction>

struct ContentLocation {
    let localURL: URL
    let remoteURL: URL
}

var configuration = Configuration()

typealias ConfigurationProvider = (Configuration) -> Void

class MainEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var onboardingService: OnboardingServiceProtocol!
    var gitService: GitServiceProtocol!
    var contentService: ContentServiceProtocol!
    
    init(configuration: Configuration, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.mainQueue = mainQueue
        setup(with: configuration)
    }
    
    func setup(with configuration: Configuration) {
        contentService = ContentService(
            contentLocation: configuration.contentLocation
        )
        
        gitService = GitService(
            contentLocation: configuration.contentLocation
        )
        
        onboardingService = OnboardingService(
            archiveURL: configuration.archiveURL,
            contentLocation: configuration.contentLocation
        )
    }
}

// MARK: State

struct MainState: Equatable {
    var snackbarData: SnackbarModifier.SnackbarData?
    var isDataAvailable: Bool = false
    var categories: [Category]?
    var selection: CategoryState?
}

// MARK: Action

enum MainAction {
    case startOnboarding
    case endOnboarding
    case cloneContent
    case updateContent
    case resetContent
    case fetchCategories
    case setCategories([Category])
    case showError(Error)
    case showMessage(title: String?, message: String, type: SnackbarModifier.SnackbarType)
    case hideSnackbar
    case goToOnboarding
    case switchContent(Configuration)

    // For navigation to Category component
    case category(CategoryAction)
    case setNavigation(selection: Category?)
}

extension MainAction: Equatable {
    static func == (lhs: MainAction, rhs: MainAction) -> Bool {
        switch (lhs, rhs) {
            case (.startOnboarding, .startOnboarding):
                return true
            case (.endOnboarding, .endOnboarding):
                return true
            case (.updateContent, .updateContent):
                return true
            case (.resetContent, .resetContent):
                return true
            case (.fetchCategories, .fetchCategories):
                return true
            case (.setCategories(let lCategories), .setCategories(let rCategories)):
                return lCategories == rCategories
            case (.showError(let lError), .showError(let rError)):
                return lError._code == rError._code
            case (.showMessage(let lTitle, let lMessage, let lType), .showMessage(let rTitle, let rMessage, let rType)):
                return lTitle == rTitle &&
                       lMessage == rMessage &&
                       lType == rType
            case (.hideSnackbar, .hideSnackbar):
                return true
            case (.goToOnboarding, .goToOnboarding):
                return true
            case (.category(let lCategoryAction), .category(let rCategoryAction)):
                return lCategoryAction == rCategoryAction
            case (.setNavigation(let lCategory), .setNavigation(let rCategory)):
                return lCategory == rCategory
            default:
                return false
        }
    }
}

// MARK: Reducer

let mainReducer = categoryReducer
    .optional
    .pullback(
        state: \MainState.selection,
        action: /MainAction.category,
        environment: {
            CategoryEnvironment(
                mainQueue: $0.mainQueue,
                contentService: $0.contentService
            )            
        }
    )
    .combined(
        with: Reducer<MainState, MainAction, MainEnvironment> { state, action, environment in
            switch action {
                case .startOnboarding:
                    return Effect(environment.onboardingService.unpackInitialContentIfNeeded())
                        .receive(on: environment.mainQueue)
                        .map { state -> MainAction in
                            switch state {
                                case .noUnpackingDone:
                                    return .cloneContent
                                default:
                                    return .updateContent
                            }
                        }
                        .catch {
                            Just(.showError($0))
                        }
                        .eraseToEffect()

                case .endOnboarding:
                    state.snackbarData = SnackbarModifier.SnackbarData.makeSuccess(detail: "Content is ready!")
                    return .none
                
                case .cloneContent:
                    return Effect(environment.gitService.clone { progress, isCompleted in
                            print(progress)
                        })
                        .receive(on: environment.mainQueue)
                        .map {
                            .updateContent
                        }
                        .catch {
                            Just(.showError($0))
                        }
                        .eraseToEffect()
                
                case .updateContent:
                    state.isDataAvailable = true
                    
                    return Effect(environment.gitService.update())
                        .receive(on: environment.mainQueue)
                        .map {
                            .endOnboarding
                        }
                        .catch {
                            Just(.showError($0))
                        }
                        .eraseToEffect()
                
                case .fetchCategories:
                    state.categories = nil
                    state.snackbarData = nil
                    return Effect(environment.contentService.fetchCategoryList())
                        .receive(on: environment.mainQueue)
                        .map {
                            .setCategories($0)
                        }
                        .catch { error -> AnyPublisher<MainAction, Never> in
                            return Just(.showError(error)).eraseToAnyPublisher()
                        }
                        .eraseToEffect()
                
                case .setCategories(let categories):
                    state.categories = categories
                    return .none
                
                case .showMessage(let title, let message, let type):
                    state.snackbarData = SnackbarModifier.SnackbarData(title: title, detail: message, type: type)
                    return .none
                
                case .showError(let error):
                    state.snackbarData = SnackbarModifier.SnackbarData.makeError(error: error)
                    return .none
                
                case .hideSnackbar:
                    state.snackbarData = nil
                    return .none
                
                case .resetContent:
                    return Effect(environment.gitService.reset())
                        .receive(on: environment.mainQueue)
                        .map { $0 ? .goToOnboarding : .showMessage(title: "Error", message: "Failed to reset content.", type: .error) }
                        .replaceError(with: .showMessage(title: "Error", message: "Failed to reset content.", type: .error) )
                        .eraseToEffect()
                
                case .switchContent(let configuration):
                    environment.setup(with: configuration)
                    return Effect(value: .goToOnboarding)
                        .eraseToEffect()
                
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
    
