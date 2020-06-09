//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
import Combine

struct MockOnboardingService: OnboardingServiceProtocol {
    
    typealias UnpackContentResult = () -> AnyPublisher<Void, Error>
    
    var unpackContentResult: UnpackContentResult
    
    init(unpackContentResult: UnpackContentResult? = nil)  {
        self.unpackContentResult = unpackContentResult ?? { Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
    }
    
    func unpackInitialContentIfNeeded() -> AnyPublisher<Void, Error> {
        return unpackContentResult()
    }
}
#endif
