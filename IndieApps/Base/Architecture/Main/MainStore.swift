//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Files
import Combine
import Foundation

typealias MainStore = Store<MainState, MainAction>

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
                    return Effect(environment.gitService.clone(branchName: nil) { progress, isCompleted in
                            //print(progress)
                            //print(isCompleted)
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
                    print(environment.configuration.contentLocation.branch)
                    return
                        Effect(
                            environment.gitService.checkoutAndUpdate(
                                branchName: configuration.contentLocation.branch
                            )
                        )
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
                    state.contentState = .unknown
                    return .none
                
                case .goToOnboarding:
                    configuration = Configuration()
                    environment.setup(with: configuration)
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
    
