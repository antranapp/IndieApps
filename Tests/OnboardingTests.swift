//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import ComposableArchitecture
import Combine
import XCTest

class OnboardingTests: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    
    func testOnboardingSucceed() {
        let store = TestStore(
            initialState: MainState(),
            reducer: mainReducer,
            environment: MockMainEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        
        store.assert(
            .send(.startOnboarding) {
                $0.contentState = .unknown
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.setContentState(.available)) {
                $0.contentState = .available
                $0.snackbarData = nil
            },
            .receive(.updateContent),
            .do {
                self.scheduler.advance()
            },
            .receive(.endOnboarding) {
                $0.contentState = .available
                $0.snackbarData = SnackbarModifier.SnackbarData.makeSuccess(detail: "Content is ready!")
            }
        )
    }
    
    func testOnboardingFailed() {
        let expectedError = NSError(domain: "SomeError", code: -1, userInfo: nil)
        let store = TestStore(
            initialState: MainState(),
            reducer: mainReducer,
            environment: MockMainEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                onboardingService: MockOnboardingService(
                    unpackContentResult: {
                        Future<OnboardingState, Error>{
                            $0(.failure(expectedError))
                        }.eraseToAnyPublisher()
                    }
                )
            )
        )
        
        store.assert(
            .send(.startOnboarding) {
                $0.contentState = .unknown
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.setContentState(.unavailable(expectedError))) {
                $0.contentState = .unavailable(expectedError)
            }
        )
    }
}
