//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import ComposableArchitecture
import Combine
import XCTest

class AppsListingTests: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    
    func testFetchAppsSucceed() {
        let store = TestStore(
            initialState: CategoryState(
                category: MockContentSevice.categoryList[0]
            ),
            reducer: categoryReducer,
            environment: CategoryEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                contentService: MockContentSevice()
            )
        )
        
        store.assert(
            .send(.fetchApps) {
                $0.apps = nil
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.setApps(MockContentSevice.appList)) {
                $0.apps = MockContentSevice.appList
            }
        )
    }
    
    func testFetchAppsFailed() {
        let expectedError = NSError(domain: "SomeError", code: -1, userInfo: nil)
        let store = TestStore(
            initialState: CategoryState(
                category: MockContentSevice.categoryList[0]
            ),
            reducer: categoryReducer,
            environment: CategoryEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                contentService: MockContentSevice(
                    appsResult: {
                        Future<[App], Error>{ $0(.failure(expectedError))}.eraseToAnyPublisher()
                    }
                )
            )
        )
        
        store.assert(
            .send(.fetchApps) {
                $0.apps = nil
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.showError(expectedError)) {
                $0.snackbarData = SnackbarModifier.SnackbarData.makeError(error: expectedError)
            }
        )
    }
}
