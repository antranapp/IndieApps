//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import ComposableArchitecture
@testable import IndieApps
import XCTest

class CategoriesListingTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testFetchCategoriesSucceed() {
        let store = TestStore(
            initialState: MainState(),
            reducer: mainReducer,
            environment: MockMainEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
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
            environment: MockMainEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                contentService: MockContentSevice(
                    categoriesResult: {
                        Future<[IndieApps.Category], Error> { $0(.failure(expectedError)) }.eraseToAnyPublisher()
                    }
                )
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
