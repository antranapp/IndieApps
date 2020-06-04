//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine

protocol OnboardingServiceProtocol {
    func unpackFTUDataIfNeeded() -> Future<Void, OnboardingServiceError>
}

class OnboardingService: OnboardingServiceProtocol {
    func unpackFTUDataIfNeeded() -> Future<Void, OnboardingServiceError> {
        return Future { promise in
            promise(.success(()))
        }
    }
}


enum OnboardingServiceError: Error {
    
}
