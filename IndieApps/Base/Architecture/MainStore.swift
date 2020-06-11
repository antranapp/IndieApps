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

typealias ConfigurationProvider = (Configuration) -> Void

protocol MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }

    var configuration: ConfigurationProtocol { get }
    var onboardingService: OnboardingServiceProtocol! { get }
    var gitService: GitServiceProtocol! { get }
    var contentService: ContentServiceProtocol! { get }
    
    func setup(with: ConfigurationProtocol)
}

var configuration = Configuration()

class MainEnvironment: MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var configuration: ConfigurationProtocol
    var onboardingService: OnboardingServiceProtocol!
    var gitService: GitServiceProtocol!
    var contentService: ContentServiceProtocol!
    
    init(
        configuration: ConfigurationProtocol,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
        self.configuration = configuration
        setup(with: configuration)
    }
    
    func setup(with configuration: ConfigurationProtocol) {
        self.configuration = configuration
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

enum ContentState: Equatable {
    case unknown
    case unavailable
    case available
}

struct MainState: Equatable {
    var snackbarData: SnackbarModifier.SnackbarData?
    var contentState: ContentState = .unknown
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
    case setContentState(ContentState, Error?)
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
            case (.setContentState(let lState, let lError), .setContentState(let rState, let rError)):
                return lState == rState &&
                    lError?._code == rError?._code
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
        with: Reducer<MainState, MainAction, MainEnvironmentProtocol> { state, action, environment in
            switch action {
                case .startOnboarding:
                    return Effect(environment.onboardingService.unpackInitialContentIfNeeded())
                        .receive(on: environment.mainQueue)
                        .map { onboardingState -> MainAction in
                            switch onboardingState {
                                case .noUnpackingDone:
                                    return .cloneContent
                                default:
                                    return .setContentState(.available, nil)
                            }
                        }
                        .catch {
                            Just(.setContentState(.unavailable, $0))
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
                            .setContentState(.available, nil)
                        }
                        .catch {
                            Just(.showError($0))
                        }
                        .eraseToEffect()
                
                case .updateContent:
                    return Effect(environment.gitService.update())
                        .receive(on: environment.mainQueue)
                        .map {
                            .endOnboarding
                        }
                        .catch {
                            Just(.showError($0))
                        }
                        .eraseToEffect()
                
                case .setContentState(let contentState, let error):
                    if let error = error {
                        state.snackbarData = SnackbarModifier.SnackbarData.makeError(error: error)
                    }
                    state.contentState = contentState
                    switch contentState {
                        case .available:
                            return Effect(value: MainAction.updateContent)
                        default:
                            return .none
                    }
                    
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
                
                case .switchContent(let newConfiguration):
                    configuration = newConfiguration
                    environment.setup(with: newConfiguration)
                    return Effect(value: .goToOnboarding)
                        .eraseToEffect()
                
                case .goToOnboarding:
                    state.contentState = .unknown
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
    
