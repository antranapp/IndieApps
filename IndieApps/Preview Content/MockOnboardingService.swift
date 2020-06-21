//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
    import Combine

    struct MockOnboardingService: OnboardingServiceProtocol {
        var unpackContentResult: AnyPublisherResultMaker<OnboardingState>

        init(unpackContentResult: AnyPublisherResultMaker<OnboardingState>? = nil) {
            self.unpackContentResult = unpackContentResult ?? { Just(OnboardingState.unpackSucceed).setFailureType(to: Error.self).eraseToAnyPublisher() }
        }

        func unpackInitialContentIfNeeded() -> AnyPublisher<OnboardingState, Error> {
            return unpackContentResult()
        }
    }
#endif
