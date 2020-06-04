//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Combine

protocol ContentServiceProtocol {
    func fetchCategoryList() -> AnyPublisher<[Category], Never>
}

class ContentService: ContentServiceProtocol {
    func fetchCategoryList() -> AnyPublisher<[Category], Never> {
        return Just([
            Category(name: "Movies"),
            Category(name: "Utilities"),
            Category(name: "Photography")
        ]).eraseToAnyPublisher()
    }
}
