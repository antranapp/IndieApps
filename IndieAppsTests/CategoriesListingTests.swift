//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import ComposableArchitecture
import Combine
import XCTest

class CategoriesListingTests: XCTestCase {
    
    let scheduler = DispatchQueue.testScheduler
    
    func testFetchCategoriesSucceed() {
        let store = TestStore(
            initialState: MainState(),
            reducer: mainReducer,
            environment: MainEnvironment(
                configuration: Configuration(),
                mainQueue: self.scheduler.eraseToAnyScheduler()
//                onboardingService: MockOnboardingService(),
//                gitService: MockGitService(),
//                contentService: MockContentSevice()
            )
        )
        
        store.assert(
            .send(.fetchCategories) {
                $0.categories = nil
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.setCategories(MockContentSevice.categoryList)) {
                $0.categories = MockContentSevice.categoryList
            }
        )
    }
    
    func testFetchCategoriesFailed() {
        let expectedError = NSError(domain: "SomeError", code: -1, userInfo: nil)
        let store = TestStore(
            initialState: MainState(),
            reducer: mainReducer,
            environment: MainEnvironment(
                configuration: Configuration(),
                mainQueue: self.scheduler.eraseToAnyScheduler()
//                onboardingService: MockOnboardingService(),
//                gitService: MockGitService(),
//                contentService: MockContentSevice(
//                    categoriesResult: {
//                        Future<[IndieApps.Category], Error>{ $0(.failure(expectedError))}.eraseToAnyPublisher()
//                    }
//                )
            )
        )
        
        store.assert(
            .send(.fetchCategories) {
                $0.categories = nil
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
