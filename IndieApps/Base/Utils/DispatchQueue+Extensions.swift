//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine
import Foundation

extension DispatchQueue {
    
    /// Dispatch block asynchronously
    /// - Parameter block: Block
    func publisher<Output, Failure: Error>(_ block: @escaping (Future<Output, Failure>.Promise) -> Void) -> AnyPublisher<Output, Failure> {
        Future<Output, Failure> { promise in
            self.async { block(promise) }
        }.eraseToAnyPublisher()
    }
}
