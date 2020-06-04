//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Files
import Combine

protocol ContentServiceProtocol {
    func fetchCategoryList() -> AnyPublisher<[Category], Never>
}

class ContentService: ContentServiceProtocol {
    
    var appFolder: Folder
    var dataFolder: Folder
    
    init(rootFolder: Folder) {
        self.appFolder = try! rootFolder.subfolder(named: "apps")
        self.dataFolder = try! rootFolder.subfolder(named: "data")
    }
        
    // MARK: APIs
    
    func fetchCategoryList() -> AnyPublisher<[Category], Never> {
        let categories = appFolder.subfolders.compactMap {
            Category(name: $0.name)
        }
        return Just(categories).eraseToAnyPublisher()
    }
}
