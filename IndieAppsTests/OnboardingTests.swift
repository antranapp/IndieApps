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
            environment: MainEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                onboardingService: MockOnboardingService(),
                gitService: MockGitService(),
                contentService: MockContentSevice()
            )
        )
        
        store.assert(
            .send(.startOnboarding) {
                $0.isDataAvailable = false
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.updateContent),
            .do {
                self.scheduler.advance()
            },
            .receive(.endOnboarding) {
                $0.isDataAvailable = true
            }
        )
    }
    
    func testOnboardingFailed() {
        let expectedError = NSError(domain: "SomeError", code: -1, userInfo: nil)
        let store = TestStore(
            initialState: MainState(),
            reducer: mainReducer,
            environment: MainEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                onboardingService: MockOnboardingService(unpackContentResult: {
                    Future<Void, Error>{ $0(.failure(expectedError))}.eraseToAnyPublisher()
                }),
                gitService: MockGitService(),
                contentService: MockContentSevice()
            )
        )
        
        store.assert(
            .send(.startOnboarding) {
                $0.isDataAvailable = false
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.showError(expectedError)) {
                $0.showSnackbar = true
                $0.snackbarData = SnackbarModifier.SnackbarData.makeError(error: expectedError)
            }
        )
    }
}
