//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
import Combine

typealias AnyPublisherResultMaker<T> = () -> AnyPublisher<T, Error>
typealias FuterResultMaker<T> = () -> Future<T, Error>

#endif
