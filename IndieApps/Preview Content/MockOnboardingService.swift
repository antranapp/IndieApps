//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
import Combine

struct MockOnboardingService: OnboardingServiceProtocol {
    
    var unpackContentResult: AnyPublisherResultMaker<Void>
    
    init(unpackContentResult: AnyPublisherResultMaker<Void>? = nil)  {
        self.unpackContentResult = unpackContentResult ?? { Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
    }
    
    func unpackInitialContentIfNeeded() -> AnyPublisher<Void, Error> {
        return unpackContentResult()
    }
}
#endif
