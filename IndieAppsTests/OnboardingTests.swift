//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
@testable import IndieApps
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
}
