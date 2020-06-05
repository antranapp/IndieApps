//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import Foundation

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State
    
    private let reducer: Reducer<State, Action, Environment>
    private let environment: Environment
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }
    
    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }
        
        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}

func appReducer(
    state: inout AppState,
    action: AppAction,
    environment: World) -> AnyPublisher<AppAction, Never>? {
    switch action {
        case .startOnboarding:
            return environment.onboardingService
                .unpackInitialContentIfNeeded()
                .receive(on: RunLoop.main)
                .map { AppAction.updateContent }
                .catch { error in
                    return Just(AppAction.showError(error))
                }
                .eraseToAnyPublisher()
        
        case .endOnboarding:
            state.isDataAvailable = true
        
        case .updateContent:
            return environment.gitService?
                .update()
                .map { AppAction.endOnboarding }
                .replaceError(with: AppAction.endOnboarding)
                .eraseToAnyPublisher()
        
        case .fetchCategoryList:
            return environment.contentService
                .fetchCategoryList()
                .map { AppAction.setCategoryList($0)}
                .eraseToAnyPublisher()
        
        case .setCategoryList(let categoryList):
            state.categoryList = categoryList
        
        case .fetchAppList(let category):
            return environment.contentService
                .fetchAppList(in: category)
                .map { AppAction.setAppList($0)}
                .eraseToAnyPublisher()

        case .setAppList(let appList):
            state.appList = appList
        

        case .showMessage(let title, let message, let type):
            state.snackbarData = SnackbarModifier.SnackbarData(title: title, detail: message, type: type)
            state.showSnackbar = true

        case .showError(let error):
            state.snackbarData.makeError(title: "Error!", detail: error.localizedDescription)
            state.showSnackbar = true

        case .hideSnackbar:
            state.showSnackbar = false
        
        case .resetContent:
            return environment.gitService?
                .reset()
                .receive(on: RunLoop.main)
                .map { $0 ? AppAction.goToOnboarding : AppAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) }
                .replaceError(with: AppAction.showMessage(title: "Error", message: "Failed to reset content.", type: .error) )
                .eraseToAnyPublisher()
        
        case .goToOnboarding:
            state.isDataAvailable = false
        
        case .noop: break // NO-OP
    }
    
    return Empty().eraseToAnyPublisher()
}

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?
