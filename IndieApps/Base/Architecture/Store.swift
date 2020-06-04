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
        case .fetchCategoryList:
            return environment.contentService
                .fetchCategoryList()
                .map { AppAction.setCategoryList($0)}
                .eraseToAnyPublisher()
        case .setCategoryList(let categoryList):
            state.categoryList = categoryList
        case .startOnboarding:
            return nil
    }
    
    return Empty().eraseToAnyPublisher()
}

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?
