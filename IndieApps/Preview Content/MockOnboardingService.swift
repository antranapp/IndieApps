//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
import Combine

struct MockOnboardingService: OnboardingServiceProtocol {
    func unpackInitialContentIfNeeded() -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif
