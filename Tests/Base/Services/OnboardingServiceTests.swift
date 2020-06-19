//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import Combine
import XCTest

class OnboardingServiceTests: TestCase {
    
    var cancellable: AnyCancellable?
    
    func testUnpackContentSuccesfully() {
        let configuration = MockConfiguration()
        let onboardingService = OnboardingService(
            archiveURL: configuration.archiveURL,
            contentLocationProvider: { configuration.contentLocation }
        )
        
        XCTAssertFalse(onboardingService.isCheckFileAvailable(at: configuration.contentLocation.localURL))
        
        let expectation = self.expectation(description: #function)
        cancellable = onboardingService.unpackInitialContentIfNeeded().sink(
            receiveCompletion: {  completion in
                if case .failure = completion {
                    XCTFail("should not fail")
                }
            },
            receiveValue: { state in
                XCTAssertEqual(state, OnboardingState.unpackSucceed)
                expectation.fulfill()
            }
        )
        
        waitForExpectations(timeout: TimeOut.short, handler: nil)
    }
}
